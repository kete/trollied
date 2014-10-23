require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "trollied"
    gem.summary = %Q{Extendable Ruby on Rails engine for adding shopping cart functionality to a Rails application. It does not assume shipping, price, or having a quantity.}
    gem.description = %Q{Extendable Ruby on Rails engine for adding shopping cart functionality to a Rails application. It does not assume shipping, price, or having a quantity. However, it does allow for more than one order per user placed in a trolley. Meant to be well suited to ordering digital records.}
    gem.email = "walter@katipo.co.nz"
    gem.homepage = "http://github.com/kete/trollied"
    gem.authors = ["Walter McGinnis"]
    gem.add_dependency "workflow", "1.0.0"
    gem.add_dependency "will_paginate", "<= 2.3.15"
    gem.add_development_dependency "shoulda", ">= 2.10.3"
    gem.add_development_dependency "factory_girl", "= 1.2.3"
    gem.add_development_dependency "webrat", ">= 0.5.3"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  puts "This gem includes a full rails app for running tests (and staging development not yet extracted to the gem proper). Run tests there by changing to test/full_[RAIlS_VERSION_#_with_underscores]_app_with_tests and doing 'rake test'."
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "trollied #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
