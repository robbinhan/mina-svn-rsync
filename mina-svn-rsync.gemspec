# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mina/svn/rsync/version'

Gem::Specification.new do |spec|
  spec.name          = "mina-svn-rsync"
  spec.version       = Mina::Svn::Rsync::VERSION
  spec.authors       = ["robbinhan"]
  spec.email         = ["luckyhanbin@gmail.com"]
  spec.summary       = %q{mina svn and rsync gem}
  spec.description   = %q{mina svn and rsync gem}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end