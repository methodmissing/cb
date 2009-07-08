class RubyCallback
  def initialize(object = nil, method = :call, &b)
    @object, @method = object, method
    @object ||= b
  end
  
  def call(*args)
    @object.__send__(@method, *args)
  end
end

module Kernel
  private
  def RubyCallback(object = nil, method = :call, &b)
    RubyCallback.new(object, method, &b)
  end
end