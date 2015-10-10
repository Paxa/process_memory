$:.unshift File.expand_path('../lib', File.dirname(__FILE__))

require 'weakref'
require "minitest/autorun"
require 'process_memory'

describe ProcessMemory do

  def take_memory
    s = "xxxx_yyyy" * 10_000_000
    a = [1, 2, "3", {a: "string"}] * 1_000
    s = WeakRef.new(s)
    a = WeakRef.new(a)
    GC.start
    return nil
  end

  def parse_ps_cmd
    pid, size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$$}"`.strip.split.map(&:to_i)
    size * 1024
  end

  it "should return current process memory" do
    ps_result = parse_ps_cmd
    gem_result = ProcessMemory.current

    # should be almost same, within 1%
    assert_in_delta ps_result, gem_result, ps_result / 100.0
  end

  it "should return current process memory when it's growing" do
    take_memory
    ps_result = parse_ps_cmd
    gem_result = ProcessMemory.current

    # should be almost same, within 1%
    assert_in_delta ps_result, gem_result, ps_result / 100.0
  end

  it "should convert bites to megabites" do
    assert_equal ProcessMemory.bites_to_human(100), "0.000MB"
    assert_equal ProcessMemory.bites_to_human(1024), "0.001MB"
    assert_equal ProcessMemory.bites_to_human(1024 * 1024), "1.000MB"
    assert_equal ProcessMemory.bites_to_human(1024 * 1024 * 123.456), "123.456MB"
    assert_equal ProcessMemory.bites_to_human(1024 * 1024 * 1024 * 4), "4096.000MB"
  end

  it "should return current memory usage in megabites" do
    current_mb = (ProcessMemory.current / 1024.0 / 1024.0).round(3)
    assert_equal ProcessMemory.human_size, "#{current_mb}MB"
  end

end
