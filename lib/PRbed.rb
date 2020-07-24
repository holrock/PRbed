require "PRbed/version"

module PRbed
  class PRBedError < StandardError; end

  HOMO_A1 = 0
  MISSING = 1
  HETERO = 2
  HOMO_A2 = 3

  SAMPLES_PER_BYTE = 4

  Fam = Struct.new(:fid, :iid, :sex, :phenotype)
  Bim = Struct.new(:chr, :vid, :bp, :a1, :a2)

  class BytesParser
    def initialize(nsamples)
      @nsamples = nsamples
      @bufsize = (@nsamples + 3) & ~3
    end

    def parse(bs)
      a = Array.new(@bufsize, MISSING)
      i = 0
      bs.each_byte do |c|
        a[i    ] =  c & 0b00000011
        a[i + 1] = (c & 0b00001100) >> 2
        a[i + 2] = (c & 0b00110000) >> 4
        a[i + 3] = (c & 0b11000000) >> 6
        i += SAMPLES_PER_BYTE
      end
      a.pop(@bufsize - @nsamples)
      a
    end
  end

  class Reader
    attr_reader :fam, :bim

    def initialize(bfile)
      @bfile = bfile
      @fam = load_fam("#{bfile}.fam")
      @bim = load_bim("#{bfile}.bim")
    end

    def each_variants
      nsamples = @fam.size
      mod = nsamples % SAMPLES_PER_BYTE
      nread_bytes = nsamples / SAMPLES_PER_BYTE
      nread_bytes += 1 unless mod ==0

      File.open("#{@bfile}.bed", "rb") do |f|
        raise PRBedError.new("not plink bed file") unless f.read(3) == "\x6c\x1b\x01"
        parser = BytesParser.new(nsamples)
        buf = '\x0' * nsamples
        @bim.each do |v|
          b = f.read(nread_bytes, buf)
          raise PRBedError.new("unpxpected file end") unless b
          a = parser.parse(b)
          yield(v, @fam, a)
        end
      end
    end

    alias_method :each, :each_variants

    private

    def load_fam(fam)
      fs = []
      File.open(fam) do |f|
        while s = f.gets
          s.chomp!
          fid, iid, _, _, sex, pheno = s.split(/\s/)
          fs.push(Fam.new(fid, iid, Integer(sex, 10), Integer(pheno, 10)))
        end
      end
      fs
    end

    def load_bim(bim)
      bs = []
      File.open(bim) do |f|
        while s = f.gets
          s.chomp!
          chr, vid, _, bp, a1, a2 = s.split(/\s/)
          bs.push(Bim.new(Integer(chr, 10), vid, Integer(bp, 10), a1, a2))
        end
      end
      bs
    end
  end
end
