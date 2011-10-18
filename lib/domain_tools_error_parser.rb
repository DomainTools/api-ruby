module DomainToolsErrorParser
  class ErrorParser
    
    def self.default_error
      {:code => 0, :message => "Unknown error message"}
    end
    
    def self.from_json(source)                  
      error = self.default_error
      json = ActiveSupport::JSON.decode(source)      
      return error = {} unless json.kind_of?(Hash) && json.has_key?("error")
      error[:code]      = json["error"]["code"]    if json["error"].has_key? "code"
      error[:message]   = json["error"]["message"] if json["error"].has_key? "message"
      error
    end

    def self.from_xml(source)
      error = self.default_error
      doc = REXML::Document.new(source)
      return error unless doc.kind_of?(REXML::Document) && doc.elements && doc.elements.size > 0
      return error unless doc.elements["whoisapi"].elements["error"]
      error[:code]      = doc.elements["whoisapi"].elements["error"].elements["code"].first
      error[:message]   = doc.elements["whoisapi"].elements["error"].elements["message"].first
      error
    end
    
  end
end