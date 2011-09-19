require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "jira4r-straightjacket"
    gem.summary = %Q{JIRA Soap Interface Gem}
    gem.description = %Q{JIRA Soap Interface Gem}
    gem.email = "tastyhat@jamesstuart.org"
    gem.homepage = "http://github.com/tastyhat/jira4r"
    gem.authors = ["James Stuart"]
    gem.add_dependency "soap4r-straightjacket"
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "jira4r #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'net/http'
require 'fileutils'
require 'rake/clean'
require 'rake/gempackagetask'

gem 'soap4r-straightjacket'

require 'wsdl/soap/wsdl2ruby'

desc "gets the wsdl files for JIRA services"
task :getwsdl do
  versions().each { |version| 
    save(getWsdlFileName(version), get_file("jira.codehaus.org", "/rpc/soap/jirasoapservice-v#{version}?wsdl"))
  }
end

task :build_gem do
  system("gem build jira4r.gemspec")
end

task :clean do
  def unl(file)
    File.unlink(file) if File.exist?(file)
  end
  unl("wsdl/jirasoapservice-v2.wsdl")
  unl("lib/jira4r/v2/jiraService.rb")
  unl("lib/jira4r/v2/jiraServiceDriver.rb")
  unl("lib/jira4r/v2/jiraServiceMappingRegistry.rb")
end

task :install_gem do
  system("gem install *.gem")
end  

task :deploy_gem do
  system("scp *.gem codehaus03:/home/projects/jira4r/snapshots.dist/distributions/")
end

desc "generate the wsdl"
task :generate do
  versions().each { |version|
    wsdl = getWsdlFileName(version)
    basedir = "lib/jira4r/v#{version}"
    mkdir_p basedir

    if not File.exist?(wsdl)
      raise "WSDL does not exist: #{wsdl}"
    end
    wsdl_url = "file://#{File.expand_path(wsdl)}"

    # Create the server
    worker = WSDL::SOAP::WSDL2Ruby.new
    #worker.logger = logger
    worker.location = wsdl_url
    worker.basedir = basedir
    worker.opt['force'] = true
    worker.opt['classdef'] = "jiraService"
    worker.opt['module_path'] ="Jira4R::V#{version}"
    
    worker.opt['mapping_registry'] = true
    #worker.run
    
    #Create the driver
    #worker = WSDL::SOAP::WSDL2Ruby.new
    #worker.logger = logger
    #worker.location = wsdl_url
    #worker.basedir = basedir
    #worker.opt['force'] = true
    #worker.opt['module_path'] = "Jira4R::V#{version}"

    worker.opt['driver'] = "JiraSoapService"
    worker.run
  }
end

def versions 
 [ 2 ]
end

def get_file(host, path)
    puts "getting http://#{host}#{path}"
    http = Net::HTTP.new(host)
    http.start { |w| w.get2(path).body }
end

def getWsdlFileName(vName)
  "wsdl/jirasoapservice-v#{vName}.wsdl"
end


# Saves this document to the specified @var path.
# doesn't create the file if contains markup for 404 page
def save( path, content )
  File::open(path, 'w') { | f | 
    f.write( content ) 
  }
end

def fix_soap_files(version)
  fix_require("lib/jira4r/v#{version}/jiraServiceMappingRegistry.rb")
  fix_require("lib/jira4r/v#{version}/JiraSoapServiceDriver.rb")
end

def fix_require(filename)
  content = ""
  File.open(filename) { |io| 
    content = io.read()
    
    content = fix_content(content, 'jiraService')
    content = fix_content(content, 'jiraServiceMappingRegistry')
  }
  
  File.open(filename, "w") { |io| 
    io.write(content)
  }
end

def fix_content(content, name)
  return content.gsub("require '#{name}.rb'", "require File.dirname(__FILE__) + '/#{name}.rb'")
end