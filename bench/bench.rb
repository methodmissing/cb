require "benchmark"
require File.dirname(__FILE__) + "/../ext/callback/callback"
require File.dirname(__FILE__) + "/pure_ruby_cb"

TESTS = 10_000
Benchmark.bmbm do |results|
  results.report("Callback{ 'hai' }.call") { TESTS.times { Callback{ 'hai' }.call } }  
  results.report("RubyCallback{ 'hai' }.call") { TESTS.times { RubyCallback{ 'hai' }.call } }
  results.report("Callback( 'bai', :to_s ).call") { TESTS.times { Callback( 'bai', :to_s ).call } }  
  results.report("RubyCallback( 'bai', :to_s ).call") { TESTS.times { RubyCallback( 'bai', :to_s ).call } }  
  results.report("Callback( 'bai', :gsub ).call( 'b', 'h' )") { TESTS.times { Callback( 'bai', :gsub ).call( 'b', 'h' ) } }  
  results.report("RubyCallback( 'bai', :gsub ).call( 'b', 'h' )") { TESTS.times { RubyCallback( 'bai', :gsub).call( 'b', 'h' ) } }
end