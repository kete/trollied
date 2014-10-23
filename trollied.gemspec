# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "trollied"
  spec.version       = File.exist?('VERSION') ? File.read('VERSION') : ""
  spec.authors       = ["Walter McGinnis"]
  spec.email         = ["wm@waltermcginnis.com"]
  spec.summary       = %Q{Extendable Ruby on Rails engine for adding shopping cart functionality to a Rails application. It does not assume shipping, price, or having a quantity.}
  spec.description   = %Q{Extendable Ruby on Rails engine for adding shopping cart functionality to a Rails application. It does not assume shipping, price, or having a quantity. However, it does allow for more than one order per user placed in a trolley. Meant to be well suited to ordering digital records.}
  spec.homepage      = "http://github.com/kete/trollied"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_dependency "workflow", "~ 0.8.0"
  spec.add_dependency "will_paginate", "<= 2.3.15"
  spec.add_development_dependency "shoulda", ">= 2.10.3"
  spec.add_development_dependency "factory_girl", "= 1.2.3"
  spec.add_development_dependency "webrat", ">= 0.5.3"
end
