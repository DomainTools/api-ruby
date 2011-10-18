module DomainToolsErrorParser
  class ErrorParser
    include DomainToolsXmlParser
    include DomainToolsJsonParser
    
    def self.default_error
      {:code => 0, :message => "Unknown error message"}
    end
    
    def self.from_json(source)                  
      hash = JSONParser::parse(source)
      hash["error"]
    end

    def self.from_xml(source)
      hash = XMLParser::parse(source)
      hash["error"]
    end
    
  end
end