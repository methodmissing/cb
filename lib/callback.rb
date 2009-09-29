require 'mri_callback'

# A simple __send__ based callback implementation, simply Object Orients
# something equivalent to:
#
#  lambda { |*args| object.__send__ method, *args }
class Callback
  class << self; attr_reader :extension_loaded; end

  begin
    cb = new(self, :instance_variable_set)
    cb.respond_to?(:call) && cb.call(:@extension_loaded, true)
  rescue ArgumentError
    @extension_loaded = false
  end

  unless @extension_loaded
    warn "Using pure ruby Callback"
    def initialize(object, method)
      @object, @method = object, method
    end

    def call(*args)
      @object.__send__(@method, *args)
    end
  end
end

# A quick monkey patch providing a public equivalent of the #method private
# method aliased to #callback. This is intended for use as a persistent
# callback object. It should be noted that using Method objects under MRI has
# in the past lead to user induced leaks. One must be careful when using it.
class Object
  alias callback method

  # Allow users to call object.callback(:method_name) to grab a Method object.
  public :callback
end

# Utility method for coercing arguments to an object that responds to #call
# Accepts an object and a method name to send to, or a block, or an object
# that responds to call.
#
#  cb = Callback{ |msg| puts(msg) }
#  cb.call('hello world')
#
#  cb = Callback(Object, :puts)
#  cb.call('hello world')
#
#  cb = Callback(proc{ |msg| puts(msg) })
#  cb.call('hello world')
module Kernel
  def Callback(object = nil, method = nil, &blk)
    if object && method
      Callback.new(object, method)
    else
      if object.respond_to? :call
        object
      else
        if object && blk || blk.nil?
          raise(ArgumentError, "Callback required an object responding to #call or an object and a method, or a block")
        else
          blk
        end
      end
    end
  end
  private :Callback
end