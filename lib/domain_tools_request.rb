module  DomainToolsRequest
  class Request
                
    def credentials=(credentials)
      return false unless credentials.kind_of? Hash
      @username  = credentials[:username]
      @key       = credentials[:key]
    end
      
    def username=(username)
      @username = username
    end
    
    def key=(key)
      @key = key
    end    
    
    def domain=(domain)
      @domain = domain
    end
    
    def service=(service)
      @service = service
    end
    
    def options=(options)
      @options = options
      @options = self.vars_hash_to_string(@options) if @options.kind_of? Hash
    end
    
    def version=(version)
      @version = version
    end
    
    def host=(host)
      @host = host
    end    
    
    def port=(port)
      @port = port
    end  
                  
    def format
      @format
    end      
    
    def format=(format)
      @format = format
    end
    
    def done?
      return @done
    end
    
    def error?
      return !@error.nil?
    end
    
    def success?
      return @error.nil? && @http && @http.body    
    end
                                                
    def [](key)
      self.do unless done? 
      @response[key]
    end
    
    # build service url
    def build_url                 
      parts = []
      parts << "/#{@version}"         if @version
      parts << "/#{@domain}"          if @domain
      parts << "/#{@service}"         if @service
      parts << "?"
      parts << "format=#{@format}"
      parts << "&api_username=#{@username}&api_key=#{@key}"
      parts << "&query=#{@query}"     if @query              
      parts << "#{@options}"          if @options
      @url = parts.join("")                    
    end
    
    def validate                                              
      raise DomainTools::NoDomainException unless @domain || @query
      # must be a valid format (will be default TYPE constant if empty or wrong)
      @format   = DomainTools::FORMAT   if @format!="json" && @format!="xml"
      # if not set with "with" function, use default
      @host     = DomainTools::HOST     if !@host
      @port     = DomainTools::PORT     if !@port
      @version  = DomainTools::VERSION  if !@version
    end
    
    
    # Connect to the server and execute the request
    def do       
      validate     
      build_url                         
      @done = true
      DomainTools.new!
      begin
        Net::HTTP.start(@host) do |http|
          req = Net::HTTP::Get.new(@url)
          # Requesting
          @http = http.request(req)       
          @success = validate_http_status     
          return finalize
        end
      rescue DomainTools::ServiceException => e                               
        @error = DomainTools::Error.new(self,e)
        raise e.class.new(e)
      end
    end
      
    def error
      @error ? @error : nil
    end
       
    # Check HTTP request status and raise an exception if needed
    def validate_http_status    
      return true if @http.code.to_i == 200
      DomainToolsExceptions::raise_by_code(@http.code)
    end   
       
    def finalize                           
      @response = DomainTools::Response.new(self.clone)
    end
    
    def content
      return @http.body if @http.body
      self.inspect
    end
           
    def to_json
      return @response.to_json if @response
      @format = "json"
      self.do
    end
    
    def to_xml
      return @response.to_xml if @response
      @format = "xml"
      self.do
    end
    
    def to_yaml
      return @response.to_yaml if @response
      nil
    end
    
    
  end
end