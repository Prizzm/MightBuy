# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "premailer-rails3"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Philipe Fatio"]
  s.date = "2011-09-29"
  s.description = "This gem brings you the power of the premailer gem to Rails 3\n                     without any configuration needs. Create HTML emails, include a\n                     CSS file as you do in a normal HTML document and premailer will\n                     inline the included CSS."
  s.email = ["philipe.fatio@gmail.com"]
  s.homepage = "https://github.com/fphilipe/premailer-rails3"
  s.require_paths = ["lib"]
  s.rubyforge_project = "premailer-rails3"
  s.rubygems_version = "1.8.24"
  s.summary = "Easily create HTML emails in Rails 3."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<premailer>, ["~> 1.7"])
      s.add_runtime_dependency(%q<rails>, ["~> 3"])
      s.add_development_dependency(%q<rspec-core>, [">= 0"])
      s.add_development_dependency(%q<rspec-expectations>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<mail>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<hpricot>, [">= 0"])
    else
      s.add_dependency(%q<premailer>, ["~> 1.7"])
      s.add_dependency(%q<rails>, ["~> 3"])
      s.add_dependency(%q<rspec-core>, [">= 0"])
      s.add_dependency(%q<rspec-expectations>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<mail>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<hpricot>, [">= 0"])
    end
  else
    s.add_dependency(%q<premailer>, ["~> 1.7"])
    s.add_dependency(%q<rails>, ["~> 3"])
    s.add_dependency(%q<rspec-core>, [">= 0"])
    s.add_dependency(%q<rspec-expectations>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<mail>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<hpricot>, [">= 0"])
  end
end
