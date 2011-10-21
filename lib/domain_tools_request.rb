module  DomainToolsRequest
  class Request
    attr_accessor :domain, :format, :service

    def initialize(data)
      data.each{|key, value| set_data(key,value)}
    end
    
    def sign(active)
      @signed = active
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
      uri   = ""
      parts << "/#{@version}"         if @version
      parts << "/#{@domain}"          if @domain
      parts << "/#{@service}"         if @service
      uri   =  parts.join("")
      parts << "?"
      parts << "format=#{@format}"
      parts << "&#{authentication_params(uri)}"
      parts << "&query=#{@query}"     if @query              
      parts << "#{@options}"          if @options
      @url = parts.join("")                      
    end
    
    def authentication_params(uri)                                      
      return "&api_username=#{@username}&api_key=#{@key}" unless @signed
      timestamp = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
      data      = @username+timestamp+uri                                             
      require 'openssl'
      digester  = OpenSSL::Digest::Digest.new(DomainTools::DIGEST)
      signature = OpenSSL::HMAC.hexdigest(digester, @key, data)
      ["api_username=#{@username}","signature=#{signature}","timestamp=#{timestamp}"].join("&")
    end
    
    
    def validate
      raise DomainTools::NoDomainException unless @domain || @query
      raise DomainTools::NoCredentialsException unless @username || @key
      # must be a valid format (will be default FORMAT constant if empty or wrong)
      @format       = DomainTools::FORMAT     if @format!="json" && @format!="xml" && @format != "html"
      # if not already defined, use default
      @host         = DomainTools::HOST       if @host.nil?
      @port         = DomainTools::PORT       if @port.nil?  
      @signed       = DomainTools::SIGNED     if @signed.nil?
      @version      = DomainTools::VERSION    if @version.nil?
    end
    
    def do
      execute
    end      
    
    def do!
      execute(true)
    end
    
    # Connect to the server and execute the request
    def execute(refresh=false)
      return @response if @response && !refresh       
      validate     
      build_url                         
      @done = true
      DomainTools.counter!
      begin
        Net::HTTP.start(@host) do |http|
          req = Net::HTTP::Get.new(@url)          
          @http = http.request(req)       
          @success = validate_http_status     
          return finalize
        end
      rescue DomainTools::ServiceException => e                               
        @error = DomainTools::Error.new(self,e)
        raise e.class.new(e)
      end
    end
    
    def response
      self.do
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
      @http ? @http.body : nil
    end   

    # Response aliases
    
    def to_s
      return @response.to_s if @response
      self.do.to_s
    end   
    
    def to_hash
      return @response.to_hash if @response
      self.do.to_hash
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
    
    private 
    
    def set_data(key,val)
      eval("@#{key.to_s} = val")
    end
    
  end
end