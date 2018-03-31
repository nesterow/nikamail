# -*- encoding: utf-8 -*-
# stub: rack-session-file 0.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rack-session-file".freeze
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["ITO Nobuaki".freeze]
  s.date = "2012-11-06"
  s.description = "A rack-based session store on plain file system.".freeze
  s.email = ["daydream.trippers@gmail.com".freeze]
  s.homepage = "".freeze
  s.rubygems_version = "2.6.14.1".freeze
  s.summary = "A rack-based session store on plain file system".freeze

  s.installed_by_version = "2.6.14.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>.freeze, [">= 1.1.0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 1.2.9"])
    else
      s.add_dependency(%q<rack>.freeze, [">= 1.1.0"])
      s.add_dependency(%q<rspec>.freeze, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<rack>.freeze, [">= 1.1.0"])
    s.add_dependency(%q<rspec>.freeze, [">= 1.2.9"])
  end
end
