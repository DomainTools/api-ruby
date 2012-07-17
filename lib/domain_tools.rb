DOMAIN_TOOLS_BASE_PATH = File.dirname(__FILE__)

module DomainTools

  # Defaut HOST for the request
  HOST      = "api.domaintools.com"
  # HOST for the Free API
  FREE_HOST = "freeapi.domaintools.com"
  
  # Use Signed Authentication
  SIGNED    = true              
  # Digest method used for HMAC signature
  DIGEST    = "sha256"
  # Default PORT for the request
  PORT      = "80"
  # Default VERSION for the request
  VERSION   = "v1"
  # Default FORMAT for the request
  FORMAT    = "json"
  
end

require "#{DOMAIN_TOOLS_BASE_PATH}/domain_tools/exceptions"   # Exceptions classes declaration
require "#{DOMAIN_TOOLS_BASE_PATH}/domain_tools/json_parser"  # JSON parser methods
require "#{DOMAIN_TOOLS_BASE_PATH}/domain_tools/xml_parser"   # XML parser methods
require "#{DOMAIN_TOOLS_BASE_PATH}/domain_tools/error"        # Error class
require "#{DOMAIN_TOOLS_BASE_PATH}/domain_tools/error_parser" # Response error parser (JSON/XML)
require "#{DOMAIN_TOOLS_BASE_PATH}/domain_tools/request"      # Request class
require "#{DOMAIN_TOOLS_BASE_PATH}/domain_tools/response"     # Response class
require "#{DOMAIN_TOOLS_BASE_PATH}/domain_tools/util"         # Tools lib
require "#{DOMAIN_TOOLS_BASE_PATH}/domain_tools/core"         # Core methods