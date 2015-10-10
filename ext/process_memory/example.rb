require './process_memory_ext'

mem = ProcessMemoryExt.get_current_rss
puts "Process memory: #{mem / 1024}KB"

s_time = Time.now

1_000_000.times do |i|
  mem = ProcessMemoryExt.get_current_rss
end
time = Time.now - s_time

puts "1_000_000 calls complete in #{time} seconds"
puts "#{time / 1000} ms per call"