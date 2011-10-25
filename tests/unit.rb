require "test/unit"
require "lib/domain_tools"
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

  def test_raise_no_domain_exception_if_no_params
    DomainTools.clear
    settings = VALID_SETTINGS.clone
    settings.delete(:domain)
    request = DomainTools::clear::with(settings).request
    assert_raises DomainTools::NoDomainException do
      request.do
    end
  end

  def test_raise_no_credentials_exception
    DomainTools.clear
    request   = DomainTools::get("whois")::on("domaintools.com").request                      
    assert_raises DomainTools::NoCredentialsException do
      request.response
    end
  end

  def test_nothing_raised_if_query_specified
    DomainTools.clear
    settings = VALID_SETTINGS.clone
    settings.delete(:domain)
    settings[:query] = {"query" => "domain tools"}
    request = DomainTools::clear::with(settings).request
    assert_nothing_raised do
      request.do
    end
  end

  def test_nothing_raised_if_parameters_specified
    DomainTools.clear
    settings = VALID_SETTINGS.clone
    settings.delete(:domain)
    settings[:parameters] = {"terms" => "DomainTools LLC|Seattle"}
    request = DomainTools::clear::with(settings).request
    assert_nothing_raised do
      request.do
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

  # Formats tests
  # ---------------------------------------------------------------
  def test_format_as_xml
    request = DomainTools::clear::with(VALID_SETTINGS).request
    request.format = "xml"
    request.do
    assert_equal request.format, "xml"
  end

  def test_format_as_json
    request = DomainTools::clear::with(VALID_SETTINGS).request
    request.format = "json"
    request.do
    assert_equal request.format, "json"
  end

  def test_format_as_html
    request = DomainTools::clear::with(VALID_SETTINGS).request
    request.format = "html"
    request.do
    assert_equal request.format, "html"
  end

  def test_format_default_fallback_as_json
    request = DomainTools::clear::with(VALID_SETTINGS).request
    request.do
    assert_equal request.format, "json"
  end

  def test_format_invalid_fallback_as_json
    request = DomainTools::clear::with(VALID_SETTINGS).request
    request.format = "notavalidformat"
    request.do
    assert_equal request.format, "json"
  end

end