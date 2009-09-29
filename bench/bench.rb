require "benchmark"
require "callback"
require "pure_ruby_cb"

class Object
  public :method
end

def meth
  'hai'
end

TESTS = 10_000
Benchmark.bmbm do |results|
  results.report("Method object:") { TESTS.times { method(:meth).call } }
  results.report("Callback{ 'hai' }.call") { TESTS.times { Callback{ 'hai' }.call } }  
  results.report("RubyCallback{ 'hai' }.call") { TESTS.times { RubyCallback{ 'hai' }.call } }
  results.report("Callback( 'bai', :to_s ).call") { TESTS.times { Callback( 'bai', :to_s ).call } }  
  results.report("RubyCallback( 'bai', :to_s ).call") { TESTS.times { RubyCallback( 'bai', :to_s ).call } }  
  results.report("Callback( 'bai', :gsub ).call( 'b', 'h' )") { TESTS.times { Callback( 'bai', :gsub ).call( 'b', 'h' ) } }  
  results.report("RubyCallback( 'bai', :gsub ).call( 'b', 'h' )") { TESTS.times { RubyCallback( 'bai', :gsub).call( 'b', 'h' ) } }
end