require "test_helper"

class PRbedTest < Minitest::Test
  def test_bytes_parse
    b = ::PRbed::BytesParser.new(4)
    assert_equal([::PRbed::HOMO_A2] * 4, b.parse("\xff"))
    b = ::PRbed::BytesParser.new(5)
    assert_equal([::PRbed::HOMO_A1] * 5, b.parse("\x00\x00"))    
    b = ::PRbed::BytesParser.new(7)
    assert_equal([::PRbed::HOMO_A2] * 7, b.parse("\xff\xff"))
    b = ::PRbed::BytesParser.new(8)
    assert_equal(([::PRbed::HOMO_A1] * 4) + ([::PRbed::HOMO_A2] * 4), b.parse("\x00\xff"))
  end

  def test_reader
    r = ::PRbed::Reader.new(File.join(__dir__, "test"))

    fam = [
      ::PRbed::Fam.new("1", "1", 1, -9),
      ::PRbed::Fam.new("1", "2", 2, -9),
      ::PRbed::Fam.new("1", "3", 1, 2),
      ::PRbed::Fam.new("2", "1", 1, -9),
      ::PRbed::Fam.new("2", "2", 2, 2),
      ::PRbed::Fam.new("2", "3", 1, 2),
    ]
    assert_equal fam, r.fam

    expects = [
      [::PRbed::Bim.new(1, "snp1", 1, "G", "A"),
        fam, [::PRbed::HOMO_A1,
              ::PRbed::HOMO_A2,
              ::PRbed::MISSING,
              ::PRbed::HOMO_A2,
              ::PRbed::HOMO_A2,
              ::PRbed::HOMO_A2]],
      [::PRbed::Bim.new(1, "snp2", 2, "1", "2"),
        fam, [::PRbed::HOMO_A2,
              ::PRbed::MISSING,
              ::PRbed::HETERO,
              ::PRbed::HOMO_A2,
              ::PRbed::HOMO_A2,
              ::PRbed::HOMO_A2]],
      [::PRbed::Bim.new(1, "snp3", 3, "A", "C"),
        fam, [::PRbed::HOMO_A2,
              ::PRbed::HETERO,
              ::PRbed::HETERO,
              ::PRbed::MISSING,
              ::PRbed::MISSING,
              ::PRbed::HOMO_A1]],                     
    ]
    i = 0
    r.each_variants do |v, fam, geno|
      assert_equal expects[i][0], v
      assert_equal expects[i][1], fam
      assert_equal expects[i][2], geno
      i += 1
    end
  end
end
