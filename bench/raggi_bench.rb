require "benchmark"
$:.unshift "."
require File.dirname(__FILE__) + "/../ext/callback/callback"
require File.dirname(__FILE__) + "/pure_ruby_cb"

@s = 'foo'
def me; @s.to_s; end
ld = lambda { @s.to_s }
cb = Callback &ld
c2 = Callback( @s, :to_s )
rb = RubyCallback { @s.to_s }
farm = @s.callback(:to_s)

tests = 100_000
puts "# Calling"
Benchmark.bmbm do |results|
  results.report("methback:") { tests.times { me      } }
  results.report("lambdabk:") { tests.times { ld.call } }
  results.report("callback:") { tests.times { cb.call } }
  results.report("callbak2:") { tests.times { c2.call } }
  results.report("rubyback:") { tests.times { rb.call } }
  results.report("farm:") { tests.times { farm.call } }
end