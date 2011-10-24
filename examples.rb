# 1. PREPARE THE ENVIRONMENT
# ------------------------------------------------------------

# 1.A Define settings step by step  
DomainTools::use(DOMAINTOOLS_USERNAME,DOMAINTOOLS_KEY)
DomainTools::get("whois")
DomainTools::as("json")
DomainTools::on("domaintools.com")

# 1.B With a hash (useful with a configuraton file)
DomainTools::with({
  :username   => DOMAINTOOLS_USERNAME,
  :key        => DOMAINTOOLS_KEY,
  :format     => "json",
  :domain     => "domaintools.com"
})     
  
# 1.C In line  
DomainTools::use(DOMAINTOOLS_USERNAME,DOMAINTOOLS_KEY)::get("whois")::as("json")::on("domaintools.com")

# 2. GET RAW API RESULT
# ------------------------------------------------------------

# 2.A The "step by step" way
request         = DomainTools.request
request.format  = "json"                # Optional, already defined above in default behaviors
request.domain  = "domaintools.com"     # Optional, already defined above in default behaviors
response        = request.do
@example1       = response.to_s

# 2.B The inline way
@example2       = DomainTools::as("json")::on("domaintools.com").response

# 2.C The implicit way, using all the default behaviors
@example3       = DomainTools.request.response 
# Equivalent of 
@example4       = DomainTools.request.do
# And even
@example5       = DomainTools.do

# 3. BROWSE AN API RESPONSE
# ------------------------------------------------------------

# 3.A The "do it yourself" way 
# ... see above to make a request ... 
response        = request.response
hash            = ActiveSupport::JSON.decode(response.content)  # with XML format use REXML (or a custom lib like Hpricot)
@example1       = hash["response"]["registration"]["registrar"]

# 3.B The "auto parse" way
# ... see above to make a request ... 
response        = request.response
@example2       = response.to_hash["response"]["registration"]["registrar"]

# 3.C The short way
# ... see above to make a request ... 
@example3       = request.do["response"]["registration"]["registrar"]

# 4. ERROR HANDLING
# ------------------------------------------------------------

# 4.A When you execute a request, it can raise an exception, you need to be ready to catch it
begin
  # ... see above to make a request ... 
  request.domain  = "domaintoolscom"          # This is a invalid domain, it will raise an exception
  request.response                            # Execute the request
  @example1       = "I will never be seen"
rescue DomainTools::ServiceException => e
  if request.error?
    @example1 = "#{e.class}: #{request.error}"
    # you can also get the error code with  request.error.code
    # and the error message with            request.error.message
  else
    @example1 = "The request has no error but raises an exception. Unlikely to hapenned"
  end
end

# 5. SYNTAX & FORMAT FLEXIBILITY
# ------------------------------------------------------------

# The idea behind this wrapper is to allow you to choose the syntax that feets your style.
# The lib will assume for you that you need to start a request only when you print or browse a response.
# You can use the module itself, the request or the response and ask for format changes or object browsing,
# it will just do the effort for you and prepare/execute/parse the whole request
# Some examples: 
                                                                                                                                    
# 5.A Inline request to get a result (Warning: no error handling!)
@example8 = DomainTools::use(DOMAINTOOLS_USERNAME,DOMAINTOOLS_KEY)::get("whois")::as("json")::on("domaintools.com")["response"]["registration"]["registrar"]

# 5.B Complex example, switching between format and service

# Set credentials and create a new request
request = DomainTools::use(DOMAINTOOLS_USERNAME,DOMAINTOOLS_KEY).request
# Set the domain
request.domain  = "domaintools.com"
# Set the format
request.format  = "json"
# Execute the request (and then get a json result)
@example1       = request.do
# Recreate a valid xml with the parsed json (no new request made)
@example2       = request.to_xml!
# print some debug  as yaml
puts            request.to_yaml
# finally just get a specific data
@example4       = request["response"]["registration"]["registrar"]
# Note: Despite all manipulations, only ONE API request has been made
# We change the service
request.service = "hosting-history"                                 
# And the response format
request.format  = "json"
# And we force a new request with ("do!" instead of "do")
@example5       = request.do!
@example6       = request["response"]["ip_history"].first["actiondate"]