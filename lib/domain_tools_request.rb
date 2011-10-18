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
      return @error.nil?
    end
    
    def success?
      return @error.nil? && @response && @response.body    
    end
    
    def error_message
      return nil unless @error
      "[#{@error[:code]}] #{@error[:message]}"
    end
    
    # -----------------------------------------------------------------------
    # -----------------------------------------------------------------------
    
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
      begin
        Net::HTTP.start(@host) do |http|
          req = Net::HTTP::Get.new(@url)
          # Requesting
          @response = http.request(req)       
          @done = validate_http_status     
          return finalize
        end
      rescue DomainTools::ServiceException => e
        get_error                                                
        raise e.class.new error_message
      end
    end
      
    def get_error
      if @format=="xml"
        @error = DomainTools::ErrorParser.from_xml(@response.body)
      else
        @error = DomainTools::ErrorParser.from_json(@response.body)
      end                                                          
    end
       
    # Check HTTP request status and raise an exception if needed
    def validate_http_status    
      return true if @response.code.to_i == 200
      DomainToolsExceptions::raise_by_code(@response.code)
    end   
       
    def finalize
      DomainTools::Response.new(self.clone)
    end
    
    def content
      return @response.body if @response.body
      self.inspect
    end
    
  end
end