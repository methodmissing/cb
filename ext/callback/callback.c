#include "ruby.h"

typedef struct {
    VALUE object;
	ID method;
} RCallback;

#define GetCallbackStruct(obj)	(Check_Type(obj, T_DATA), (RCallback*)DATA_PTR(obj))

VALUE rb_cCallback;

static ID id_call;

static void free_callback(RCallback* cb)
{
    xfree(cb);
}

static VALUE callback_alloc _((VALUE));
static VALUE
callback_alloc( VALUE klass )
{
	VALUE cb;
	RCallback* cbs;
	cb = Data_Make_Struct(klass, RCallback, 0, free_callback, cbs);
    cbs->object = Qnil;
	cbs->method = 0;
	
    return cb;
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
	RCallback* cbs = GetCallbackStruct(cb);
	 
	if (rb_block_given_p()) {
	  if (argc == 1) rb_raise(rb_eArgError, "wrong number of arguments");
	    cbs->object = rb_block_proc();
	    cbs->method = id_call;
    }else {
	    rb_scan_args(argc, argv, "02", &object, &method);
	    cbs->object = object;
	    cbs->method = rb_to_id(method);
    }

	OBJ_FREEZE(cb);
	return cb;
}

static VALUE rb_callback_call( VALUE cb, VALUE args )
{
	RCallback* cbs = GetCallbackStruct(cb);
	return rb_apply(cbs->object, cbs->method, args); 
}

static VALUE rb_f_callback( int argc, VALUE *argv )
{
	return rb_callback_initialize( argc, argv, rb_callback_new() );
}

static VALUE
rb_obj_callback( VALUE obj, VALUE mid)
{
	VALUE args[2];
	args[0] = obj;
	args[1] = mid; 
	return rb_f_callback( 2, (VALUE *)args );
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
    rb_define_method(rb_mKernel, "callback", rb_obj_callback, 1);
}	