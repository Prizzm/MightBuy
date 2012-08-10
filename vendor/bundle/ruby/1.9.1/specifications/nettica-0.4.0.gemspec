# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "nettica"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Conway"]
  s.date = "2010-03-29"
  s.email = "matt@conwaysplace.com"
  s.executables = ["nettica"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["bin/nettica", "README.rdoc"]
  s.homepage = "http://github.com/wr0ngway/nettica"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "A ruby client for managing nettica bulk-dns entries using the Nettica SOAP API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mumboe-soap4r>, [">= 0"])
    else
      s.add_dependency(%q<mumboe-soap4r>, [">= 0"])
    end
  else
    s.add_dependency(%q<mumboe-soap4r>, [">= 0"])
  end
end
