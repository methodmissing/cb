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

=begin
macbook-pros-computer:callback lourens$ ruby bench/bench.rb
Rehearsal ---------------------------------------------------------------------------------
Callback{ 'hai' }.call                          0.030000   0.000000   0.030000 (  0.035764)
RubyCallback{ 'hai' }.call                      0.070000   0.000000   0.070000 (  0.064418)
Callback( 'bai', :to_s ).call                   0.010000   0.000000   0.010000 (  0.008680)
RubyCallback( 'bai', :to_s ).call               0.030000   0.000000   0.030000 (  0.034922)
Callback( 'bai', :gsub ).call( 'b', 'h' )       0.020000   0.000000   0.020000 (  0.025700)
RubyCallback( 'bai', :gsub ).call( 'b', 'h' )   0.070000   0.000000   0.070000 (  0.064520)
------------------------------------------------------------------------ total: 0.230000sec

                                                    user     system      total        real
Callback{ 'hai' }.call                          0.030000   0.000000   0.030000 (  0.031178)
RubyCallback{ 'hai' }.call                      0.060000   0.000000   0.060000 (  0.062691)
Callback( 'bai', :to_s ).call                   0.010000   0.000000   0.010000 (  0.008189)
RubyCallback( 'bai', :to_s ).call               0.040000   0.000000   0.040000 (  0.034988)
Callback( 'bai', :gsub ).call( 'b', 'h' )       0.020000   0.000000   0.020000 (  0.025773)
RubyCallback( 'bai', :gsub ).call( 'b', 'h' )   0.070000   0.000000   0.070000 (  0.065348)
=end