module DomainToolsResponse
  class Response          
    include DomainToolsXmlParser
    include DomainToolsJsonParser
    
    def initialize(request)
      @request = request
    end                    
    
    def request
      @request
    end     
    
    def content
      request.content
    end
    
    def to_s
      @request.content
    end           
                                                 
    # Return XML with parsed object (no new request made)
    def to_xml!
      @parsed_object = parse unless @parsed_object
      @parsed_object.to_xml({:root => 'whoisapi'})
    end             

    # Execute the same request and return an XML response with a NEW request    
    def to_xml
      @request.clone.to_xml
    end
               
    # Return JSON with parsed object (no new request made)
    def to_json!
      @parsed_object = parse unless @parsed_object
      @parsed_object.to_json
    end        

    # Execute the same request and return a JSON response with a NEW request
    def to_json
      @request.clone.to_json
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
      return XMLParser::parse(@request.content) if @request.format == "xml"
      JSONParser::parse(@request.content)
    end
    
  end
end