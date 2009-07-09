#include "ruby.h"

struct RCallback {
    struct RBasic basic;
    VALUE object;
	ID method;
};

#define RCALLBACK(obj)  (R_CAST(RCallback)(obj))

VALUE rb_cCallback;

static ID id_call;

static VALUE callback_alloc _((VALUE));
static VALUE
callback_alloc( VALUE klass )
{
    NEWOBJ(cb, struct RCallback);
    /* trick gc_mark_children */
    OBJSETUP(cb, klass, T_BLKTAG); 

    cb->object = Qnil;
	cb->method = 0;
	
    return (VALUE)cb;
}

static VALUE
rb_callback_new()
{
    return callback_alloc(rb_cCallback);
}

static VALUE rb_callback_initialize( int argc, VALUE *argv, VALUE cb )
{
	VALUE object;
	VALUE method;
	 
	if (rb_block_given_p()) {
  	  if (argc == 1) rb_raise(rb_eArgError, "wrong number of arguments");
	  RCALLBACK(cb)->object = rb_block_proc();
	  RCALLBACK(cb)->method = id_call;
    }else {
	  rb_scan_args(argc, argv, "02", &object, &method);
	  RCALLBACK(cb)->object = object;
	  RCALLBACK(cb)->method = rb_to_id(method);
    }
	rb_gc_mark(RCALLBACK(cb)->object);
	rb_gc_mark(RCALLBACK(cb)->method);	
	OBJ_FREEZE(cb);
	return cb;
}

static VALUE rb_callback_call( VALUE cb, VALUE args )
{
	return rb_funcall2(RCALLBACK(cb)->object, RCALLBACK(cb)->method, -1, &args); 
}

static VALUE rb_f_callback( int argc, VALUE *argv )
{
	return rb_callback_initialize( argc, argv, rb_callback_new() );
}

void
Init_callback()
{
	id_call = rb_intern("call");
	
	rb_cCallback  = rb_define_class("Callback", rb_cObject);
    rb_define_alloc_func(rb_cCallback, callback_alloc);
    
    rb_define_method(rb_cCallback,"initialize", rb_callback_initialize, -1);
    rb_define_method(rb_cCallback,"call", rb_callback_call, -2);

    rb_define_global_function("Callback", rb_f_callback, -1);
}	