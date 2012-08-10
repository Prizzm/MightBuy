# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "slim-rails"
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Leonardo Almeida"]
  s.date = "2010-11-04"
  s.description = "Provide generators for Rails 3"
  s.email = "lalmeida08@gmail.com"
  s.extra_rdoc_files = ["LICENSE", "README.md"]
  s.files = ["LICENSE", "README.md"]
  s.homepage = "http://github.com/leogalmeida/slim-rails"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Provides generators for Rails 3"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<slim>, [">= 0.9.2"])
    else
      s.add_dependency(%q<slim>, [">= 0.9.2"])
    end
  else
    s.add_dependency(%q<slim>, [">= 0.9.2"])
  end
end
