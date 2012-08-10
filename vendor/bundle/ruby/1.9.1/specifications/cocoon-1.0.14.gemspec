# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "cocoon"
  s.version = "1.0.14"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nathan Van der Auwera"]
  s.date = "2011-10-21"
  s.description = "Unobtrusive nested forms handling, using jQuery. Use this and discover cocoon-heaven."
  s.email = "nathan@dixis.com"
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["README.markdown"]
  s.homepage = "http://github.com/nathanvda/cocoon"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "gem that enables easier nested forms with standard forms, formtastic and simple-form"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rails>, [">= 3.0.0"])
      s.add_development_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_development_dependency(%q<json_pure>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 2.6.0"])
      s.add_development_dependency(%q<rspec>, [">= 2.6.0"])
      s.add_development_dependency(%q<actionpack>, [">= 3.0.0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<generator_spec>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
    else
      s.add_dependency(%q<rails>, [">= 3.0.0"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_dependency(%q<json_pure>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, [">= 2.6.0"])
      s.add_dependency(%q<rspec>, [">= 2.6.0"])
      s.add_dependency(%q<actionpack>, [">= 3.0.0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<generator_spec>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.0.0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.0.0"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
    s.add_dependency(%q<json_pure>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, [">= 2.6.0"])
    s.add_dependency(%q<rspec>, [">= 2.6.0"])
    s.add_dependency(%q<actionpack>, [">= 3.0.0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<generator_spec>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.0.0"])
  end
end
