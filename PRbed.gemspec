require_relative 'lib/PRbed/version'

Gem::Specification.new do |spec|
  spec.name          = "PRbed"
  spec.version       = PRbed::VERSION
  spec.authors       = ["holrock"]
  spec.email         = ["ispeporez@gmail.com"]

  spec.summary       = %q{PLINK bed file reader}
  spec.description   = %q{pure ruby implementation of PLINK bed file stream reader}
  spec.homepage      = "https://github.com/holrock/PRbed"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
