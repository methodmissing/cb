#include "ruby.h"

#ifndef RSTRING_PTR
#define RSTRING_PTR(obj) RSTRING(obj)->ptr
#endif

typedef struct {
    VALUE object;
	ID method;
} RCallback;

#define GetCallbackStruct(obj)	(Check_Type(obj, T_DATA), (RCallback*)DATA_PTR(obj))

VALUE rb_cCallback;
static ID id_call;

static void mark_mri_callback(RCallback* cb)
{
    rb_gc_mark(cb->object);
}

static void free_mri_callback(RCallback* cb)
{
    xfree(cb);
}

static VALUE callback_alloc _((VALUE));
static VALUE
callback_alloc( VALUE klass )
{
	VALUE cb;
	RCallback* cbs;
	cb = Data_Make_Struct(klass, RCallback, mark_mri_callback, free_mri_callback, cbs);
    cbs->object = Qnil;
	cbs->method = 0;
	
    return cb;
}

static VALUE
rb_mri_callback_new()
{
    return callback_alloc(rb_cCallback);
}

static VALUE rb_mri_callback_initialize( int argc, VALUE *argv, VALUE cb )
{
	VALUE object;
	VALUE method;
	ID meth;
	RCallback* cbs = GetCallbackStruct(cb);
	 
	if (rb_block_given_p()) {
	  if (argc == 1) rb_raise(rb_eArgError, "wrong number of arguments");
	    cbs->object = rb_block_proc();
	    cbs->method = id_call;
    }else {
	    rb_scan_args(argc, argv, "02", &object, &method);
	    cbs->object = object;
	    meth = rb_to_id(method);
	    if (!rb_respond_to(object,meth)) rb_raise(rb_eArgError, "object does not respond to %s", RSTRING_PTR(rb_obj_as_string(method)));
	    cbs->method = meth;
    }

	OBJ_FREEZE(cb);
	return cb;
}

static VALUE rb_mri_callback_call( VALUE cb, VALUE args )
{
	RCallback* cbs = GetCallbackStruct(cb);
	return rb_apply(cbs->object, cbs->method, args); 
}

void
Init_mri_callback()
{
    id_call = rb_intern("call");
 
    rb_cCallback  = rb_define_class("Callback", rb_cObject);
    rb_define_alloc_func(rb_cCallback, callback_alloc);
    
    rb_define_method(rb_cCallback,"initialize", rb_mri_callback_initialize, -1);
    rb_define_method(rb_cCallback,"call", rb_mri_callback_call, -2);
}	