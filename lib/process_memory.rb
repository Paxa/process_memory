require 'process_memory/process_memory_ext'

module ProcessMemory
  extend self

  def current
    return ProcessMemoryExt.get_current_rss
    ProcessMemoryExt.get_peak_rss
  end

  def peak
    ProcessMemoryExt.get_peak_rss
  end

  def human_size
    bites_to_human(current)
  end

  def bites_to_human(num)
    "%.3fMB" % (num / (1024 * 1024.0))
  end

  def start_recording(resolution = 0.1)
    recorder = Recorder.new(resolution)
    recorder.start
    recorder
  end

  class Recorder
    def initialize(resolution = 0.1)
      @resolution = resolution
      #@semaphore = Mutex.new
      @tracks = []
      @running = false
      @initial_memory = ProcessMemory.current
    end

    def start
      data = @tracks
      timeout = @resolution
      @start_time = Time.now
      @running = true
      @runner_thread = Thread.new do
        while true
          data << [Time.now, ProcessMemory.current]
          sleep(timeout)
        end
      end
    end

    def stop
      @running = false
      @runner_thread.kill
    end

    def print(msg = nil)
      'PROC_MEM [pid: %d t: %.3f ram: +%s] %s' % [
        Process.pid,
        Time.now - @start_time,
        ProcessMemory.bites_to_human(ProcessMemory.current - @initial_memory),
        msg.to_s
      ]
    end

    def report_per_second
      if @running
        raise "profiling is still running, call ProcessMemory::Recorder#stop to stop it"
      end

      per_second = {}
      per_second[0] = [@tracks.first[1]]

      @tracks.each do |time, memory|
        seconds = (time - @start_time).ceil
        per_second[seconds] ||= []
        per_second[seconds] << memory
        #per_second[seconds] = memory
      end

      per_second.each do |time, memories|
        per_second[time] = memories.max
      end

      return per_second
    end

    def report_per_second_pretty
      data = report_per_second
      time_size = data.keys.max.to_s.size

      result = "Start MEM: #{ProcessMemory.bites_to_human(@initial_memory)}\n"
      data.each do |second, memory|
        result << "SEC: #{second.to_s.ljust(time_size)} : +#{ProcessMemory.bites_to_human(memory - @initial_memory)}\n"
      end

      return result
    end
  end
end