module  DomainToolsRequest
  class Request

    def initialize(data)
       @username  = data[:username] if data[:username]
       @key       = data[:key]      if data[:key]               
       @domain    = data[:domain]   if data[:domain]
       @service   = data[:service]  if data[:service]
       @options   = data[:options]  if data[:options]
       @format    = data[:format]   if data[:format]
       @host      = data[:host]     if data[:host]
       @port      = data[:port]     if data[:port]
       @version   = data[:version]  if data[:version]
    end
                  
    def format
      @format
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
      DomainTools.counter!
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
    
    def to_s
      return @response.to_s if @response
      self.do.to_s
    end
           
    def to_json
      return @response.to_json if @response
      @format = "json"
      self.do
    end
    
    def to_json!
      return @response.to_json! if @response
      self.do.to_json!
    end
    
    def to_xml
      return @response.to_xml if @response
      @format = "xml"
      self.do
    end     
    
    def to_xml!
      return @response.to_xml! if @response
      self.do.to_xml!
    end
    
    def to_yaml
      return @response.to_yaml if @response
      nil
    end
    
    
  end
end