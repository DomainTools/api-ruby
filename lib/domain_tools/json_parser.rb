module DomainTools
  class JSONParser          
                  
    def self.parse(source)
      require('json')
      JSON.parse(source)
    end
    
  end
end