# -----------------------------------------------------------------------------
# 5. SYNTAX & FORMAT FLEXIBILITY
# -----------------------------------------------------------------------------

# The idea behind this wrapper is to allow you to choose the syntax that feets your style.
# The lib will assume for you that you need to start a request only when you print or browse a response.
# You can use the module itself, the request or the response and ask for format changes or object browsing,
# it will just do the effort for you and prepare/execute/parse the whole request
# Here down a complete example of requests, responses, tests...
                                                               
                                                               
# Set credentials and create a new request
request = DomainTools::use(DOMAINTOOLS_USERNAME,DOMAINTOOLS_KEY).request
# Set the domain
request.domain  = "domaintools.com"
# Set the format
request.format  = "json"
# Execute the request (and then get a json result)
begin
  @example1       = request.do.to_s
  # Recreate a valid xml with the parsed json (no new request made)
  @example2       = request.to_xml!
  # print some debug  as yaml
  puts request.to_yaml
  # finally just get a specific data 
  begin
    @example3       = request["response"]["registrant"]["name"]
  rescue NoMethodError => e # If you try to browse nil
    @example3       = "Unable to find registrant name"
  end
  # Note: Despite all manipulations, only ONE API request has been made
  # We change the service
  request.service = "hosting-history"                                 
  # And the response format
  request.format  = "xml"
  # And we force a new request with ("do!" instead of "do")
  @example4       = request.do!
  begin
    @example5 = request["response"]["ip_history"].first["actiondate"]
  rescue NoMethodError => e
    @example5 = "No IP history"
  end
rescue  DomainTools::ServiceException => e
  if request && request.error?
    @error = "#{e.class}: #{request.error}"
  else
    @error = "Unknown error: #{e.message}"
  end
end