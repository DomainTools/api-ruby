module DomainTools              
  unloadable # development, to avoid reloading server at each change...
  
  require 'net/http'
  # HTTPS not supported yet
  #require 'net/https'
  
  include DomainToolsUtil
  include DomainToolsExceptions
  include DomainToolsErrorParser  
  include DomainToolsRequest
  include DomainToolsResponse
  include DomainToolsError
                       
  # Defaut HOST for the request
  HOST    = "api.domaintools.com"
  # Default PORT for the request
  PORT    = "80"
  # Default VERSION for the request
  VERSION = "v1"
  # Default FORMAT for the request
  FORMAT  = "json"      
    
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
  
  # Select which service must be called for this request
  def self.get(service)
    self.set_data :service, service
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
    self.set_data(:host,    settings[:host])    if settings[:host]
    self.set_data(:port,    settings[:port])    if settings[:port]
    self.set_data(:version, settings[:version]) if settings[:version]
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
    @request = DomainToolsRequest::Request.new @data
    @request.do
  end                                              
  
  
  
  
  
  
  
  def self.request
    @request = DomainToolsRequest::Request.new @data unless @request
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
    @request[key]
  end
  
  def self.to_json
    return nil unless @request
    @request.to_json
  end
  
  def self.to_xml
    return nil unless @request
    @request.to_xml
  end
  
  def self.to_yaml
    return nil unless @request
    @request.to_yaml
  end          
  
  
  # Request aliases
  
  def self.done?
    self.request && self.request.done?
  end
  
  def self.error?
   self.request &&  self.request.error?
  end
  
  def self.success?
    self.request &&  self.request.success?
  end  
  
  def self.to_s
    return self.request.to_s &&  self.request
    to_s
  end
  
  def self.to_json
    return self.request.to_json &&  self.request
    to_json
  end
  
  def self.to_xml
    return self.request.to_xml &&  self.request
    to_xml
  end
  
  def self.to_yaml
    return self.request.to_yaml &&  self.request
    to_yaml
  end
  
  
  private
  
  def self.set_data(key,val)
    @data = {} unless @data
    @data[key.to_sym] = val
    self
  end
  
  
end
