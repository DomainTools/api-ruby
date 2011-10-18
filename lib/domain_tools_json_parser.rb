module DomainToolsJsonParser
  class JSONParser          
                  
    def self.parse(source)
      ActiveSupport::JSON.decode(source)
    end
    
  end
end