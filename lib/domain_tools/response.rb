module DomainTools
  class Response
    
    def initialize(request)
      @request = request.clone
    end                    
    
    def request
      @request
    end     
    
    def content
      request.content
    end      
    
    def response
      self.do
    end
    
    def do
      self
    end
    
    def to_s
      request.content
    end             
    
    def render
      to_s
    end
    
    def to_hash
      @parsed_object = parse unless @parsed_object
      @parsed_object
    end
                                                 
    # Return XML with parsed object (no new request made)
    def to_xml!
      self.to_hash.to_xml({:root => 'whoisapi'})
    end             

    # Execute the same request and return an XML response with a NEW request    
    def to_xml
      request.clone.to_xml
    end
               
    # Return JSON with parsed object (no new request made)
    def to_json!
      self.to_hash.to_json
    end        

    # Execute the same request and return a JSON response with a NEW request
    def to_json
      request.clone.to_json
    end
    
    def to_yaml
      @parsed_object = parse unless @parsed_object
      @parsed_object.to_yaml
    end        
    
    def [](key)
      @parsed_object = parse unless @parsed_object
      return @parsed_object[key.to_s] if  @parsed_object[key.to_s]
      nil
    end      
    
    private
    
    def parse
      return XMLParser::parse(request.content)        if request.format == "xml"
      return JSONParser::parse(request.content)       if request.format == "json"   
      # If HTML, we will fallback and make a new json request, then parse it
      return JSONParser::parse(self.to_json.content)  if request.format == "html"
    end
    
  end
end