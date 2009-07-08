#include "ruby.h"

/*

class Callback
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
  def Callback(object = nil, method = :call, &b)
    Callback.new(object, method, &b)
  end
end

*/

struct RCallback {
    struct RBasic basic;
    VALUE object;
	ID method;
};

#define RCALLBACK(obj)  (R_CAST(RCallback)(obj))
#define T_CALLBACK   0x0f

VALUE rb_cCallback;

static ID id_call;

callback_alloc( VALUE klass)
{
    NEWOBJ(cb, struct RCallback);
    OBJSETUP(cb, klass, T_CALLBACK);

    cb->object = Qnil;
	cb->method = Qnil;
	
    return (VALUE)cb;
}

VALUE
rb_callback_new()
{
    return callback_alloc(rb_cCallback);
}

static VALUE rb_callback_initialize( int argc, VALUE *argv, VALUE cb )
{
	VALUE object;
	VALUE method;
	 
	if (rb_block_given_p()) {
  	  if (argc > 1) rb_raise(rb_eArgError, "wrong number of arguments");
	  RCALLBACK(cb)->object = rb_block_proc();
	  RCALLBACK(cb)->method = id_call;
    }else {
	  rb_scan_args(argc, argv, "02", &object, &method);
	  RCALLBACK(cb)->object = object;
	  RCALLBACK(cb)->method = rb_to_id(method);
    }
}

static VALUE rb_callback_call( VALUE cb, VALUE args )
{
	return rb_funcall2(RCALLBACK(cb)->object, RCALLBACK(cb)->method, -1, &args); 
}

void
Init_callback()
{
	id_call = rb_intern("call");
	
	rb_cCallback  = rb_define_class("Callback", rb_cObject);
    rb_define_alloc_func(rb_cCallback, callback_alloc);
    
    rb_define_method(rb_cCallback,"initialize", rb_callback_initialize, -1);
    rb_define_method(rb_cCallback,"call", rb_callback_call, -2);

}	