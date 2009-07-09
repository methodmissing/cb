require 'mkmf'

dir_config('callback')

create_makefile('callback')

$defs.push("-DRUBY18") if have_var('rb_trap_immediate', ['ruby.h', 'rubysig.h'])