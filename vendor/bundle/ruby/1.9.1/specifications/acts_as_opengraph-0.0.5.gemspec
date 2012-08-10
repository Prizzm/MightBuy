# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "acts_as_opengraph"
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ruben Ascencio"]
  s.date = "2011-12-30"
  s.description = "ActiveRecord extension that turns your models into graph objects. Includes helper methods for adding <meta> tags and the Like Button to your views."
  s.email = ["galateaweb@gmail.com"]
  s.homepage = "https://github.com/rubenrails/acts_as_opengraph"
  s.require_paths = ["lib"]
  s.rubyforge_project = "acts_as_opengraph"
  s.rubygems_version = "1.8.24"
  s.summary = "ActiveRecord extension that turns your models into graph objects"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<rails>, [">= 0"])
    else
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 0"])
    end
  else
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 0"])
  end
end
