# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "grackle"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Hayes Davis"]
  s.date = "2012-06-10"
  s.description = "    Grackle is a library for the Twitter REST and Search API designed to not\n    require a new release in the face Twitter API changes or errors.\n"
  s.email = "hayes@unionmetrics.com"
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG.rdoc"]
  s.files = ["README.rdoc", "CHANGELOG.rdoc"]
  s.homepage = "http://github.com/hayesdavis/grackle"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Grackle is a lightweight library for the Twitter REST and Search API."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<mime-types>, [">= 0"])
      s.add_runtime_dependency(%q<oauth>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<mime-types>, [">= 0"])
      s.add_dependency(%q<oauth>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<mime-types>, [">= 0"])
    s.add_dependency(%q<oauth>, [">= 0"])
  end
end
