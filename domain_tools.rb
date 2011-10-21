module DomainTools              
  # unloadable # development, to avoid reloading server at each change...
  require 'net/http'
    
  include DomainToolsUtil
  include DomainToolsExceptions
  include DomainToolsErrorParser  
  include DomainToolsRequest
  include DomainToolsResponse
  include DomainToolsError
                       
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
    
  # Authentication of the user       
  # can be set with a hash {:username,:password} as one param
  # or with two string params
  def self.use(credentials,key=false)
    if credentials.kind_of? Hash
      self.set_data :username,  credentials[:username]
      self.set_data :key,       credentials[:key]
    else                        
      self.set_data :username,  credentials
      self.set_data :key,       key
    end
    self
  end      
  
  def self.clear
    @data = {}
    @request = nil
    self
  end
  
  # Select which service must be called for this request
  def self.get(service)
    self.set_data :service, service
  end             
  
  def self.sign(active)
    self.set_data :signed, active
  end
  
  # change the format of the response (only XML or JSON)
  def self.as(format)           
    self.set_data :format, format
  end
  
  # to specify options to the service
  def self.where(options)
    self.set_data :options, options
  end
  
  # to overide settings, only for specific cases or for testing
  def self.with(settings={})                                      
    settings.each{|key, value| set_data(key,value)}
    self
  end
  
  # Param of the request, usually a domain name or sometime the first part of a domain
  def self.on(domain)
    self.set_data :domain, domain
  end              
  
  # To define a query 
  def self.for(query)    
    self.set_data :query, query
  end
    
  # check first, raise exception if needed, execute the HTTP request
  def self.do
    self.request.do
  end 

  def self.response
    self.do
  end
  
  def self.request
    raise DomainTools::NoSettingsException unless @request
    @request
  end
  
  def self.counter
    return 0 unless @counter
    @counter
  end
  
  def self.counter!
    @counter = 0 unless @counter
    @counter+=1
  end

  def self.[](key)
    self.do unless self.done?
    self.request[key]
  end
  
  # Request aliases
  
  def self.done?
    self.request.done?
  end
  
  def self.error?
    self.request.error?
  end
  
  def self.success?
    self.request.success?
  end  
  
  def self.to_s
    self.request.to_s
  end 
  
  def self.to_hash
    self.request.to_hash
  end
  
  def self.to_json
    self.request.to_json
  end
  
  def self.to_json!
    self.request.to_json!
  end
  
  def self.to_xml
    self.request.to_xml
  end
      
  def self.to_xml! 
    self.request.to_xml!       
  end 
  
  def self.to_yaml
    self.request.to_yaml
  end         
  
  private
  
  def self.set_data(key,val)
    @data = {} unless @data
    @data[key.to_sym] = val
    # Update data for future request
    @request = DomainToolsRequest::Request.new @data
    self
  end         
  
end