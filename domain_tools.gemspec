Gem::Specification.new do |s|
  s.name        = "domain_tools"
  s.version     = "0.0.1"
  s.author      = "DomainTools, LLC"
  s.email       = "MemberServices@DomainTools.com"
  s.homepage    = "http://www.domaintools.com/api/"
  s.summary     = "Ruby gem for requesting domaintools.com webservices"
  s.description = "Ruby wrapper of the domaintools.com API, allowing you to easily request any service available on domaintools.com"
  
  s.files        = Dir["{lib,test,examples}/**/*"]
  s.require_path = "lib"
  
  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end


