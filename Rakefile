require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = Dir.glob('spec/**/*_spec.rb')
end

task(default: :test)

task :compile do
  %x{
    cd ext
    ruby ./extconf.rb
    make
  }
end
