$:.unshift File.expand_path('lib', File.dirname(__FILE__))

require 'process_memory'

recorder = ProcessMemory.start_recording

garbage = []
500_000.times do |n|
  garbage << "string #{n} -- " * 30
  sleep(0.0001) if n % 1000 == 0
  puts recorder.print("N: #{n}") if n % 50_000 == 0
end

recorder.stop

puts recorder.report_per_second_pretty
