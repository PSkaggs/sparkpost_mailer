# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sparkpost_mailer/version'

Gem::Specification.new do |spec|
  spec.name          = "sparkpost_mailer"
  spec.version       = SparkpostMailer::VERSION
  spec.authors       = ["Preston Skaggs"]
  spec.email         = ["preston@delaris.com"]

  spec.summary       = %q{A short wrapper for the sparkpost gem}
  spec.description   = %q{All this does is make the root_url and image_url available to a mailer subclass}
  spec.homepage      = "https://github.com/PSkaggs/sparkpost_mailer"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'activesupport'
  spec.add_dependency 'actionpack'
  spec.add_runtime_dependency 'sparkpost'
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'pry'
end
