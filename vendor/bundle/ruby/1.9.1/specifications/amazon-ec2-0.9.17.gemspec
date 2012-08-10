# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "amazon-ec2"
  s.version = "0.9.17"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Glenn Rempe"]
  s.date = "2010-11-21"
  s.description = "A Ruby library for accessing the Amazon Web Services EC2, ELB, RDS, Cloudwatch, and Autoscaling APIs."
  s.email = ["glenn@rempe.us"]
  s.executables = ["awshell", "ec2-gem-example.rb", "ec2-gem-profile.rb", "ec2sh", "setup.rb"]
  s.extra_rdoc_files = ["ChangeLog", "LICENSE", "README.rdoc"]
  s.files = ["bin/awshell", "bin/ec2-gem-example.rb", "bin/ec2-gem-profile.rb", "bin/ec2sh", "bin/setup.rb", "ChangeLog", "LICENSE", "README.rdoc"]
  s.homepage = "http://github.com/grempe/amazon-ec2"
  s.rdoc_options = ["--title", "amazon-ec2 documentation", "--line-numbers", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "amazon-ec2"
  s.rubygems_version = "1.8.24"
  s.summary = "Amazon EC2 Ruby gem"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<xml-simple>, [">= 1.0.12"])
      s.add_development_dependency(%q<mocha>, [">= 0.9.9"])
      s.add_development_dependency(%q<test-spec>, [">= 0.10.0"])
      s.add_development_dependency(%q<rcov>, [">= 0.9.9"])
      s.add_development_dependency(%q<perftools.rb>, [">= 0.5.4"])
      s.add_development_dependency(%q<yard>, [">= 0.6.2"])
    else
      s.add_dependency(%q<xml-simple>, [">= 1.0.12"])
      s.add_dependency(%q<mocha>, [">= 0.9.9"])
      s.add_dependency(%q<test-spec>, [">= 0.10.0"])
      s.add_dependency(%q<rcov>, [">= 0.9.9"])
      s.add_dependency(%q<perftools.rb>, [">= 0.5.4"])
      s.add_dependency(%q<yard>, [">= 0.6.2"])
    end
  else
    s.add_dependency(%q<xml-simple>, [">= 1.0.12"])
    s.add_dependency(%q<mocha>, [">= 0.9.9"])
    s.add_dependency(%q<test-spec>, [">= 0.10.0"])
    s.add_dependency(%q<rcov>, [">= 0.9.9"])
    s.add_dependency(%q<perftools.rb>, [">= 0.5.4"])
    s.add_dependency(%q<yard>, [">= 0.6.2"])
  end
end
