# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cb}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lourens Naud\303\251 (methodmissing)", "James Tucker (raggi)"]
  s.date = %q{2009-08-22}
  s.description = %q{Simple native Callback object for Ruby MRI (1.8.{6,7} and 1.9.2)}
  s.email = %q{lourens@methodmissing.com}
  s.extensions = ["ext/mri_callback/extconf.rb"]
  s.extra_rdoc_files = ["README"]
  s.files = ["README", "Rakefile", "bench/bench.rb", "bench/pure_ruby_cb.rb", "bench/raggi_bench.rb", "ext/mri_callback/extconf.rb", "ext/mri_callback/mri_callback.c", "lib/callback.rb", "test/test_callback.rb"]
  s.homepage = %q{http://github.com/methodmissing/cb}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Native MRI callback}
  s.test_files = ["test/test_callback.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
