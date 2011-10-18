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
  
                       
  # Defaut HOST for the request
  HOST    = "api.domaintools.com"
  # Default PORT for the request
  PORT    = "80"
  # Default VERSION for the request
  VERSION = "v1"
  # Default FORMAT for the request
  FORMAT  = "json"      
  
  def self.new
    @requests = [] unless @requests
    @requests << DomainToolsRequest::Request.new
    self
  end  
  
  def self.current_request
    return @requests.last if @requests && @requests.last
    @requests = [DomainToolsRequest::Request.new]
    @requests.last
  end
  
  def self.requests
    return @requests
  end               
  
  def self.first
    return @requests.first if @requests && requests.length > 0
    nil
  end
  
  def self.last
    return @requests.first if @requests && requests.length > 0
    nil
  end
  
  def self.length
    return @requests.length if @requests
    0
  end     
  
  def self.[](key)
    (self.do)[key]
  end
  
  # Authentication of the user       
  # can be set with a hash {:username,:password} as one param
  # or with two string params
  def self.use(credentials,key=false)
    if credentials.kind_of? Hash
      @credentials = credentials
      self.current_request.credentials = credentials
    else                        
      @username, @key = credentials, key
      self.current_request.username, self.current_request.key = credentials, key
    end
    self
  end
  
  # Select which service must be called for this request
  def self.get(service)
    @service = service
    self.current_request.service = service
    self
  end
  
  # change the format of the response (only XML or JSON)
  def self.as(format)
    @format = format     
    self.current_request.format = format
    self
  end
  
  # to specify options to the service
  def self.where(options)
    @options = options    
    self.current_request.options = options
    self
  end
  
  # to overide settings, only for specific cases or for testing
  def self.with(settings={})                            
    if settings[:host]
      @host = settings[:host]
      self.current_request.host = settings[:host]     
    end                                                 
    if settings[:port]
      @port = settings[:port]
      self.current_request.port = settings[:port]
    end                                              
    if settings[:version]
      @version = settings[:version]
      self.current_request.version  = settings[:version]
    end
    self
  end
  
  # Param of the request, usually a domain name or sometime the first part of a domain
  def self.on(domain,execute=true)
    @domain = domain
    self.current_request.domain = domain
    return self.do if execute
    self
  end              
  
  def self.for(query,execute=true)    
    @query = query
    self.current_request.query = query
    return self.do if execute
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
    self.current_request.do
  end                                            
  
end
