# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'typography/version'

Gem::Specification.new do |s|
  s.authors = ["Dmitry Shaposhnik", "Anton Versal", "Igor Gladkoborodov", "Pravosud Pavel"]
  s.email = ["dmitry@shaposhnik.name", "ant.ver@gmail.com", "igor@workisfun.ru"]
  s.date = "2010-11-22"
  s.homepage = "https://github.com/VerAnt/typography"
  s.rubyforge_project = ""
  s.name = TypographyHelper::GEM_NAME
  s.version = TypographyHelper::VERSION
  s.summary = "#{TypographyHelper::GEM_NAME}-#{TypographyHelper::VERSION}"
  s.description = "This gem makes text more readable by applying some typographic rules to string."
  s.files = Dir.glob("{lib,spec}/**/*") +
    ["README.rdoc", "Rakefile", "Changelog", "Gemfile", "init.rb"]

  s.test_files = Dir.glob("spec/**/*")
  s.require_path = "lib"
  s.extra_rdoc_files = ["README.rdoc"]
  s.rdoc_options = ["--main", "README.rdoc"]

  s.add_dependency "actionpack"
  s.add_development_dependency "rspec", ">= 2.0.0"
  s.add_development_dependency "autotest"
  s.add_development_dependency "ruby-debug19" if RUBY_VERSION =~ /1\.9/
end
