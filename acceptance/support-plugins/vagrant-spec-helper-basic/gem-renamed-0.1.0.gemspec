# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "vagrant-spec-helper-basic-rename"
  spec.version       = "0.1.0"
  spec.authors       = ["Mitchell Hashimoto"]
  spec.email         = ["mitchell.hashimoto@gmail.com"]
  spec.description   = %q{Gem used as a helper for vagrant-spec.}
  spec.summary       = %q{Gem used as a helper for vagrant-spec. Don't use this.}
  spec.homepage      = "https://github.com/mitchellh/vagrant-spec"
  spec.license       = "MPL2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
end
