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
  
end