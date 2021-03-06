#$:.unshift File.expand_path('lib', File.dirname(__FILE__))
#require 'looksee/version'

Gem::Specification.new do |gem|
  gem.name = 'process_memory'
  gem.version = "0.1"
  gem.authors = ["Pavel Evstigneev"]
  gem.email = ["pavel.evst@gmail.com"]
  gem.license = 'MIT'
  gem.date = '2015-10-02'
  gem.summary = "Getting process memory"
  gem.homepage = 'http://github.com/paxa/process_memory'

  gem.extensions = Dir["ext/**/extconf.rb"]

  #gem.extra_rdoc_files = ['CHANGELOG', 'LICENSE', 'README.markdown']
  gem.files = Dir['lib/**/*', 'ext/**/{*.c,*.h,*.rb}', 'CHANGELOG', 'LICENSE', 'Rakefile', 'README.md']
  gem.test_files = Dir["spec/**/*.rb"]
  gem.require_path = 'lib'

  gem.specification_version = 3
  gem.add_development_dependency "minitest", "~> 5.8"
end