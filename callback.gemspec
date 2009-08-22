Gem::Specification.new do |s|
  s.name     = "callback"
  s.version  = "1.0.0"
  s.date     = "2009-08-22"
  s.summary  = "Native MRI callback"
  s.email    = "lourens@methodmissing.com"
  s.homepage = "http://github.com/methodmissing/callback"
  s.description = "Simple native Callback object for Ruby MRI (1.8.{6,7} and 1.9.2)"
  s.has_rdoc = true
  s.authors  = ["Lourens Naudé (methodmissing)","James Tucker (raggi)"]
  s.platform = Gem::Platform::RUBY
  s.files    = %w[
    README
    Rakefile
    bench/bench.rb
    bench/pure_ruby_cb.rb
    bench/raggi_bench.rb
    ext/callback/extconf.rb
    ext/callback/callback.c
    lib/callback.rb
    callback.gemspec
  ] + Dir.glob('test/*')
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README"]
  s.extensions << "ext/callback/extconf.rb"
end