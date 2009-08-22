$:.unshift "."
require File.dirname(__FILE__) + '/helper'

class TestCallback < Test::Unit::TestCase
  
  def test_block
    cb = Callback{ 'hai' }
    assert_equal 'hai', cb.call
  end

  def test_init_object_call_with_no_args
    cb = Callback( 'bai', :to_s ) 
    assert_equal 'bai', cb.call
  end
  
  def test_init_object_call_with_args
    cb = Callback( 'bai', :gsub )
    assert_equal 'hai', cb.call( 'b', 'h' )
  end

  def test_many_calls
    cb = Callback { :foo }
    100_000.times { cb.call }
  end  
 
  def test_arguments
    assert_raises ArgumentError do
      Callback( 'hai' ){}
    end
  end

  def test_farmed_from_object
    cb = 'hai'.callback(:to_s)
    assert_equal 'hai', cb.call
    ocb = 'bai'.callback(:gsub)
    assert_equal 'hai', ocb.call('b', 'h')
  end  
  
end