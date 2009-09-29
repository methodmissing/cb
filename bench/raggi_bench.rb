require "benchmark"
require "callback"
require "pure_ruby_cb"

@s = 'foo'
def me; @s.to_s; end
ld = lambda { @s.to_s }
cb = Callback &ld
c2 = Callback( @s, :to_s )
rb = RubyCallback { @s.to_s }
farm = @s.callback(:to_s)
meth = @s.send(:method, :to_s)

tests = 100_000
puts "# Calling"
Benchmark.bmbm do |results|
  results.report("method invoked:") { tests.times { me } }
  results.report("ruby method obj:") { tests.times { meth.call } }
  results.report("object native callback:") { tests.times { farm.call } }
  results.report("callback native:") { tests.times { c2.call } }
  results.report("callback block:") { tests.times { cb.call } }
  results.report("pure ruby callback:") { tests.times { rb.call } }
  results.report("lambda:") { tests.times { ld.call } }
end