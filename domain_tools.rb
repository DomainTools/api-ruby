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
    
  def self.request
    @request = DomainToolsRequest::Request.new unless @request    
    @request
  end
  
  # Authentication of the user       
  # can be set with a hash {:username,:password} as one param
  # or with two string params
  def self.use(credentials,key=false)
    if credentials.kind_of? Hash
      @credentials = credentials
      self.request.credentials = credentials
    else                        
      @username, @key = credentials, key
      self.request.username, self.request.key = credentials, key
    end
    self
  end
  
  # Select which service must be called for this request
  def self.get(service)
    @service = service
    self.request.service = service
    self
  end
  
  # change the format of the response (only XML or JSON)
  def self.as(format)
    @format = format     
    self.request.format = format
    self
  end
  
  # to specify options to the service
  def self.where(options)
    @options = options    
    self.request.options = options
    self
  end
  
  # to overide settings, only for specific cases or for testing
  def self.with(settings={})                            
    if settings[:host]
      @host = settings[:host]
      self.request.host = settings[:host]     
    end                                                 
    if settings[:port]
      @port = settings[:port]
      self.request.port = settings[:port]
    end                                              
    if settings[:version]
      @version = settings[:version]
      self.request.version  = settings[:version]
    end
    self
  end
  
  # Param of the request, usually a domain name or sometime the first part of a domain
  def self.on(domain)
    @domain = domain
    self.request.domain = domain
    self
  end              
  
  def self.for(query)    
    @query = query
    self.request.query = query
    self
  end
  
  # Alias to make a request with only one hash
  def self.execute(params={})
    self.prepare(params)    
    self.on     params[:on] if params[:on]    
  end
  
  # used to set data but don't start the request
  def self.prepare(params={})
    raise DomainTools::WrongParmatersException unless params.kind_of? Hash
    self.use    params[:auth]     if params[:auth] 
    self.get    params[:service]  if params[:service]
    self.as     params[:format]   if params[:format] 
    self.where  params[:options]  if params[:options] 
    self.with   params[:with]     if params[:with]
    self.on(params[:on],false)    if params[:on]
    self
  end
  
  # check first, raise exception if needed, execute the HTTP request
  def self.do                    
    self.request.do
  end                                            
            
  def self.new!
    @counter = 0 unless @counter
    @counter+=1
  end       
  
  def self.counter
    return 0 unless @counter
    @counter
  end

  def self.[](key)
    return nil unless @request
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
  
  
end
