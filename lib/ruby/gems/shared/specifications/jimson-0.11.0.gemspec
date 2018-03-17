# -*- encoding: utf-8 -*-
# stub: jimson 0.11.0 ruby lib

Gem::Specification.new do |s|
  s.name = "jimson".freeze
  s.version = "0.11.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Chris Kite".freeze]
  s.date = "2016-03-14"
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze]
  s.homepage = "http://www.github.com/chriskite/jimson".freeze
  s.rubygems_version = "2.6.14.1".freeze
  s.summary = "JSON-RPC 2.0 client and server".freeze

  s.installed_by_version = "2.6.14.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<blankslate>.freeze, [">= 3.1.3", "~> 3.1"])
      s.add_runtime_dependency(%q<rest-client>.freeze, [">= 1.7.3", "~> 1"])
      s.add_runtime_dependency(%q<multi_json>.freeze, [">= 1.11.2", "~> 1"])
      s.add_runtime_dependency(%q<rack>.freeze, [">= 1.4.5", "~> 1"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 2.14.1", "~> 2.14"])
      s.add_development_dependency(%q<rack-test>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rdoc>.freeze, [">= 4.2.2", "~> 4.2"])
    else
      s.add_dependency(%q<blankslate>.freeze, [">= 3.1.3", "~> 3.1"])
      s.add_dependency(%q<rest-client>.freeze, [">= 1.7.3", "~> 1"])
      s.add_dependency(%q<multi_json>.freeze, [">= 1.11.2", "~> 1"])
      s.add_dependency(%q<rack>.freeze, [">= 1.4.5", "~> 1"])
      s.add_dependency(%q<rspec>.freeze, [">= 2.14.1", "~> 2.14"])
      s.add_dependency(%q<rack-test>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rdoc>.freeze, [">= 4.2.2", "~> 4.2"])
    end
  else
    s.add_dependency(%q<blankslate>.freeze, [">= 3.1.3", "~> 3.1"])
    s.add_dependency(%q<rest-client>.freeze, [">= 1.7.3", "~> 1"])
    s.add_dependency(%q<multi_json>.freeze, [">= 1.11.2", "~> 1"])
    s.add_dependency(%q<rack>.freeze, [">= 1.4.5", "~> 1"])
    s.add_dependency(%q<rspec>.freeze, [">= 2.14.1", "~> 2.14"])
    s.add_dependency(%q<rack-test>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rdoc>.freeze, [">= 4.2.2", "~> 4.2"])
  end
end
