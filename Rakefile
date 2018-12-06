require 'rake/testtask'
#require "rake/extensiontask"

desc "Compile native extension"
task :compile do
  %x{
    cd ext/process_memory &&
    ruby ./extconf.rb &&
    make
  }
end


#Rake::ExtensionTask.new "process_memory" do |ext|
#  ext.name = "process_memory_ext"
#  ext.lib_dir = "lib/process_memory"
#end

Rake::TestTask.new do |test|
  test.test_files = Dir.glob('spec/**/*_spec.rb')
end

task :test => :compile
task :default => :test
