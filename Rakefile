require 'rake'
require 'rake/testtask'
require 'rake/clean'

CB_ROOT = 'ext/mri_callback'

desc 'Default: test'
task :default => :test

desc 'Run callback tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << CB_ROOT
  t.pattern = 'test/test_*.rb'
  t.verbose = true
end
task :test => :build

namespace :build do
  file "#{CB_ROOT}/mri_callback.c"
  file "#{CB_ROOT}/extconf.rb"
  file "#{CB_ROOT}/Makefile" => %W(#{CB_ROOT}/mri_callback.c #{CB_ROOT}/extconf.rb) do
  Dir.chdir(CB_ROOT) do
    ruby 'extconf.rb'
  end
end

desc "generate makefile"
task :makefile => %W(#{CB_ROOT}/Makefile #{CB_ROOT}/mri_callback.c)

dlext = Config::CONFIG['DLEXT']
file "#{CB_ROOT}/mri_callback.#{dlext}" => %W(#{CB_ROOT}/Makefile #{CB_ROOT}/mri_callback.c) do
Dir.chdir(CB_ROOT) do
  sh 'make' # TODO - is there a config for which make somewhere?
end
end

desc "compile callback extension"
task :compile => "#{CB_ROOT}/mri_callback.#{dlext}"

task :clean do
  Dir.chdir(CB_ROOT) do
    sh 'make clean'
  end if File.exists?("#{CB_ROOT}/Makefile")
end

CLEAN.include("#{CB_ROOT}/Makefile")
CLEAN.include("#{CB_ROOT}/mri_callback.#{dlext}")
end

task :clean => %w(build:clean)

desc "compile"
task :build => %w(build:compile)

task :install do |t|
  Dir.chdir(CB_ROOT) do
    sh 'sudo make install'
  end
end

desc "clean build install"
task :setup => %w(clean build install)

desc "run benchmarks"
task :bench do |t|
  ruby "-Ilib:ext/mri_callback:bench", "bench/bench.rb"
  puts
  ruby "-Ilib:ext/mri_callback:bench", "bench/raggi_bench.rb"
end
task :bench => "build"