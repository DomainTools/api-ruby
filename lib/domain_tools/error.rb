module DomainTools
  class Error
    
    def initialize(request,service_excepton)
      @request = request
      @exception = service_excepton
      parse
    end

    def parse
      if @request.format=="xml"
        error = DomainTools::ErrorParser.from_xml(@request.content)
      else
        error = DomainTools::ErrorParser.from_json(@request.content)
      end
      @code, @message = error["code"], error["message"]                
    end     
    
    def to_s
      "[#{@code}] #{@message}"
    end
    
    def code
      @code
    end
    
    def message
      @message
    end
    
    def request
      @request
    end
    
    def exception
      @exception
    end
    
  end
end