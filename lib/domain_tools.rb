module DomainTools              



  # Defaut HOST for the request
  HOST      = "api.domaintools.com"
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

require "domain_tools/core"         # Core methods
require "domain_tools/json_parser"  # JSON parser methods
require "domain_tools/xml_parser"   # XML parser methods
require "domain_tools/error"        # Error class
require "domain_tools/error_parser" # Response error parser (JSON/XML)
require "domain_tools/exceptions"   # Exceptions classes declaration
require "domain_tools/request"      # Request class
require "domain_tools/response"     # Response class
require "domain_tools/util"         # Tools lib