#!/usr/bin/env rake
require 'rake/testtask'
require 'rake/clean'

def spec(file = Dir['*.gemspec'].first)
  @spec ||=
  begin
    require 'rubygems/specification'
    Thread.abort_on_exception = true
    data = File.read(file)
    spec = nil
    Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
    spec.instance_variable_set(:@filename, file)
    def spec.filename; @filename; end
    spec
  end
end

def manifest; @manifest ||= `git ls-files`.split("\n").reject{|s|s=~/\.gemspec$|\.gitignore$/}; end

@gem_package_task_type = begin
  require 'rubygems/package_task'
  Gem::PackageTask
rescue LoadError
  require 'rake/gempackagetask'
  Rake::GemPackageTask
end
def gem_task; @gem_task ||= @gem_package_task_type.new(spec); end
gem_task.define
Rake::Task[:clobber].enhance [:clobber_package]

rdoc_task_type = begin
  require 'rdoc/task'
  RDoc::Task
rescue LoadError
  require 'rake/rdoctask'
  Rake::RDocTask
end
df = begin; require 'rdoc/generator/darkfish'; true; rescue LoadError; end
rdtask = rdoc_task_type.new do |rd|
  rd.title = spec.name
  rd.main = spec.extra_rdoc_files.first
  lib_rexp = spec.require_paths.map { |p| Regexp.escape p }.join('|')
  rd.rdoc_files.include(*manifest.grep(/^(?:#{lib_rexp})/))
  rd.rdoc_files.include(*spec.extra_rdoc_files)
  rd.template = 'darkfish' if df
end

Rake::Task[:clobber].enhance [:clobber_rdoc]

require 'yaml'
require 'rake/contrib/sshpublisher'
desc "Publish rdoc to rubyforge"
task :publish => rdtask.name do
  rf_cfg = File.expand_path '~/.rubyforge/user-config.yml'
  host = "#{YAML.load_file(rf_cfg)['username']}@rubyforge.org"
  remote_dir = "/var/www/gforge-projects/#{spec.rubyforge_project}/#{spec.name}/"
  Rake::SshDirPublisher.new(host, remote_dir, rdtask.rdoc_dir).upload
end

desc 'Generate and open documentation'
task :docs => :rdoc do
  path = rdtask.send :rdoc_target
  case RUBY_PLATFORM
  when /darwin/       ; sh "open #{path}"
  when /mswin|mingw/  ; sh "start #{path}"
  else 
    sh "firefox #{path}"
  end
end

desc "Regenerate gemspec"
task :gemspec => spec.filename

task spec.filename do
  spec.files = manifest
  spec.test_files = FileList['{test,spec}/**/{test,spec}_*.rb']
  open(spec.filename, 'w') { |w| w.write spec.to_ruby }
end

desc "Bump version from #{spec.version} to #{spec.version.to_s.succ}"
task :bump do
  spec.version = spec.version.to_s.succ
end

desc "Tag version #{spec.version}"
task :tag do
  tagged = Dir.new('.git/refs/tags').entries.include? spec.version.to_s
  if tagged
    warn "Tag #{spec.version} already exists"
  else
    # TODO release message in tag message
    sh "git tag #{spec.version}"
  end
end

if spec.rubyforge_project
  desc "Release #{gem_task.gem_file} to rubyforge"
  task :release => [:tag, :gem, :publish] do |t|
    sh "rubyforge add_release #{spec.rubyforge_project} #{spec.name} #{spec.version} #{gem_task.package_dir}/#{gem_task.gem_file}"
  end
else
  warn "Cannot release to rubyforge - no rubyforge_project in gemspec"
end

CB_ROOT = 'ext/mri_callback'

desc 'Default: test'
task :default => :test

desc 'Run callback tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << CB_ROOT
  t.pattern = 'test/test_*.rb'
  t.verbose = true
end
task :test

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
task :bench