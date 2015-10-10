# ProcessMemory Gem

#### Install:

```
gem install process_memory
```

#### Usage:

```ruby
require 'process_memory'

p ProcessMemory.current # => 110465024
p ProcessMemory.human_size # => 105.347MB
```

---

**Recorder:**

```ruby
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
```

Output:
```
PROC_MEM [pid: 28805 t: 0.000 ram: +0.020MB] N: 0
PROC_MEM [pid: 28805 t: 0.094 ram: +26.824MB] N: 50000
PROC_MEM [pid: 28805 t: 0.187 ram: +54.867MB] N: 100000
PROC_MEM [pid: 28805 t: 0.295 ram: +83.840MB] N: 150000
PROC_MEM [pid: 28805 t: 0.390 ram: +114.250MB] N: 200000
PROC_MEM [pid: 28805 t: 0.495 ram: +143.523MB] N: 250000
PROC_MEM [pid: 28805 t: 0.610 ram: +173.195MB] N: 300000
PROC_MEM [pid: 28805 t: 0.697 ram: +201.309MB] N: 350000
PROC_MEM [pid: 28805 t: 0.824 ram: +228.656MB] N: 400000
PROC_MEM [pid: 28805 t: 0.933 ram: +257.691MB] N: 450000
Start MEM: 7.133MB
SEC: 0 : +0.020MB
SEC: 1 : +255.055MB
SEC: 2 : +280.262MB
```