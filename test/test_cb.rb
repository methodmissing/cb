require "test/unit"
require "cb"

class TestCallbackPureRuby < Test::Unit::TestCase
  def test_Callback_with_lambda
    ran = false
    l = lambda { ran = true }
    Callback(l).call
    assert ran
  end

  def cb
    @ran = true
  end

  def test_Callback_with_object_and_method
    @ran = false
    Callback(self, :cb).call
    assert @ran
  end

  def test_Callback_with_block
    ran = false
    Callback { ran = true }.call
    assert ran
  end

  def test_Callback_with_no_arguments
    assert_raises(ArgumentError) do
      Callback()
    end
  end

  def test_Object_callback
    @ran = false
    self.callback(:cb).call
    assert @ran
  end

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

  def test_invalid_method
    assert_raises NameError do
      'str'.callback(:undefined)
    end
  end
end