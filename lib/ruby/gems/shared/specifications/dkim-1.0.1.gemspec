# -*- encoding: utf-8 -*-
# stub: dkim 1.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "dkim".freeze
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["John Hawthorn".freeze]
  s.date = "2017-11-16"
  s.description = "gem for adding DKIM signatures to email messages".freeze
  s.email = ["john.hawthorn@gmail.com".freeze]
  s.executables = ["dkimsign.rb".freeze]
  s.files = ["bin/dkimsign.rb".freeze]
  s.homepage = "https://github.com/jhawthorn/dkim".freeze
  s.rubyforge_project = "dkim".freeze
  s.rubygems_version = "2.6.14.1".freeze
  s.summary = "DKIM library in ruby".freeze

  s.installed_by_version = "2.6.14.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0"])
      s.add_development_dependency(%q<mail>.freeze, [">= 0"])
      s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
      s.add_dependency(%q<mail>.freeze, [">= 0"])
      s.add_dependency(%q<appraisal>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_dependency(%q<mail>.freeze, [">= 0"])
    s.add_dependency(%q<appraisal>.freeze, [">= 0"])
  end
end
