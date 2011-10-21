require "test/unit"                  
# ---------------------------------------------------------
require "lib/domain_tools_json_parser"
require "lib/domain_tools_xml_parser"
require "lib/domain_tools_error"
require "lib/domain_tools_error_parser"
require "lib/domain_tools_exceptions"
require "lib/domain_tools_request"
require "lib/domain_tools_response"
require "lib/domain_tools_util"
require "domain_tools"
# ---------------------------------------------------------
begin
  require "openssl" 
rescue LoadError
  puts "Could not load 'openssl' gem, required for testing" 
  exit
end
begin
  require "json" 
rescue LoadError
  puts "Could not load 'json' gem, required for testing" 
  exit
end
# ---------------------------------------------------------

class UnitTestDomainTools < Test::Unit::TestCase
  
  VALID_SETTINGS = {
    :username   => "username",
    :key        => "key",
    :format     => "json",
    :domain     => "domaintools.com"
  }
  
  

  # Exceptions tests
  # ---------------------------------------------------------------
  
  def test_raise_no_settings_exception
    DomainTools.clear
    assert_raises DomainTools::NoSettingsException do
      DomainTools.request
    end
  end
  
  def test_raise_no_domain_exception  
    DomainTools.clear
    assert_raises DomainTools::NoDomainException do
      DomainTools::get("whois").request.do
    end
  end
  
  def test_raise_no_credentials_exception
    DomainTools.clear
    request   = DomainTools::get("whois")::on("domaintools.com").request                      
    assert_raises DomainTools::NoCredentialsException do
      request.response
    end               
  end
  
  # Classes tests
  # ---------------------------------------------------------------

  def test_module_class
    assert_equal DomainTools.class, Module
  end
                                      
  def test_module_request_class       
    request = DomainTools::get("whois").request                  
    assert_equal request.class, DomainTools::Request
  end
  
  def test_module_response_class       
    request   = DomainTools::with(VALID_SETTINGS)
    response  = request.response
    assert_equal response.class, DomainTools::Response
  end
  
  # Parsers tests
  # ---------------------------------------------------------------
  def test_json_parser
    request = DomainTools::clear::with(VALID_SETTINGS).request
    request.format = "json"
    assert_nothing_raised do
      request.response["response"] # force parsing
    end
  end
  
  def test_xml_parser
    request = DomainTools::clear::with(VALID_SETTINGS).request
    request.format = "xml"
    assert_nothing_raised do
      request.response["response"] # force parsing
    end
  end

end