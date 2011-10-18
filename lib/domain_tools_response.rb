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
    
    def to_xml
      return to_s if @request.format == "xml"
    end

    def to_json
      return to_s if @request.format == "json"
    end
    
    def to_yaml
      parse unless @parsed_object
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