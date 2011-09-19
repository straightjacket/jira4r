require 'rubygems'
require 'rake'
require 'net/http'
require 'fileutils'
require 'rake/clean'
require 'rake/gempackagetask'

require 'logger'

gem 'soap4r-straightjacket', '~> 1.5.8'

require 'wsdl/soap/wsdl2ruby'

logger = Logger.new(STDERR)
logger.level = Logger::INFO

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "gets the wsdl files for JIRA services"
task :getwsdl do
  versions().each { |version| 
    save(getWsdlFileName(version), get_file("jira.codehaus.org", "/rpc/soap/jirasoapservice-v#{version}?wsdl"))
  }
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
    worker.logger = logger
    worker.location = wsdl_url
    worker.basedir = basedir
    worker.opt['force'] = true
    worker.opt['classdef'] = "jiraService"
    worker.opt['module_path'] ="Jira4R::V#{version}"
    
    worker.opt['mapping_registry'] = true

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
