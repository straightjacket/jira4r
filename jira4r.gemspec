# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jira4r}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Stuart"]
  s.date = %q{2009-11-23}
  s.description = %q{JIRA Soap Interface Gem}
  s.email = %q{tastyhat@jamesstuart.org}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = Dir.glob("lib/**/*")
  s.files << [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "jira4r.gemspec",
     "lib/jira4r.rb",
     "lib/jira4r/jira_tool.rb",
     "lib/jira4r/server.rb",
     "lib/jira4r/v2/jira_service.rb",
     "lib/jira4r/v2/jira_service_mapping_registry.rb",
     "lib/jira4r/v2/jira_soap_service_driver.rb",
     "test/helper.rb",
     "test/test_jira4r.rb",
     "wsdl/jirasoapservice-v2.wsdl"
  ]
  s.files.flatten!
  s.homepage = %q{http://github.com/tastyhat/jira4r}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{JIRA Soap Interface Gem}
  s.test_files = [
    "test/helper.rb",
     "test/test_jira4r.rb"
  ]

  soap4r = 'soap4r-straightjacket'

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(soap4r, [">= 0"])
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(soap4r, [">= 0"])
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(soap4r, [">= 0"])
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end

