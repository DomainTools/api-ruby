module DomainTools
  extend self
  include Exceptions
  
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
  
  # Change the host, to swith between free and standard API
  def self.with_api(api)
    self.set_data :api, api
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
  
  # to specify parameters to the service
  def self.where(parameters)
    self.set_data :parameters, parameters
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
  
  def self.is_free?
    self.request.is_free?
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
    key = :host if key.to_s == 'api'
    @data[key.to_sym] = val
    # Update data for future request
    @request = DomainTools::Request.new @data
    self
  end
  
  
end