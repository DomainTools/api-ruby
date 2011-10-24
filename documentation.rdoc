# DomainTools Wrapper Documentation
  
## DomainTools Module

* DomainTools.use   (<String> username, <String> password)  # set the default credentials
* DomainTools.get   (<String> service)                      # set the default service
* DomainTools.as    (<String> format)                       # set the default format
* DomainTools.where (<String> parameters)                   # set the default parameters (&param1=ok&...)
* DomainTools.for   (<String> query)                        # set the default query variable
* DomainTools.with  (<Hash>   settings)                     # set default settings (like above) with a hash (see examples)
* DomainTools.sign  (<Boolean sign)                         # set the authentication method (signed by default)
* DomainTools.clear                                         # Reset all default configuration
* DomainTools.do                                            # Create and execute a request on the fly
* DomainTools.response                                      # *do* alias
* DomainTools.request                                       # get current request object

## DomainTools Request
(See DomainTools.request method to get a request object) 
              
### Setters
* request.domain    = "domaintools.com"     # set the domain for this request
* request.format    = "xml"                 # set the format for this request
* request.service   = "whois"               # set the service for this request
* request.query     = "Domain", :parameters # set the parameters for this request
* request.sign      (<Boolean> sign)        # Enable/disable signed authentication (default:true)
* request.done?                             # Return the request status (if *do* method as been called)
* request.error?                            # True if an error has been raised
* request.success?                          # True if no error has been raised
* request.do                                # Execute the request (only once, if done?, then does nothing). Return a response object
* request.do!                               # Execute the request (even if already done). Return a response object
* request.error                             # Return error object if there is one
* request.response                          # *do* alias

## DomainTools Response
(See DomainTools.request.response method to get a response object)

* response.request                        # Return related request
* response.content                        # Return raw API response as a String
* response.to_s                           # *content* alias
* response.to_hash                        # Return hash object of parsed API result
* response.to_xml                         # Re-Execute the request (if necessary) with XML format
* response.to_xml!                        # Create a XML with parsed result (no new request executed)
* response.to_json                        # Re-Execute the request (if necessary) with JSON format
* response.to_json!                       # Create a JSON with parsed result (no new request executed)
* response.to_yaml                        # Display a yaml view of the hash object
