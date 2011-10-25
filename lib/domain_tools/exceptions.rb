module DomainTools
  module Exceptions
    
    class ServiceException                < StandardError;    end  
    class NoSettingsException             < ServiceException; end
    class NoCredentialsException          < ServiceException; end
    class BadRequestException             < ServiceException; end
    class NotAuthorizedException          < ServiceException; end
    class NotFoundException               < ServiceException; end
    class InternalServerErrorException    < ServiceException; end
    class ServiceUnavailableException     < ServiceException; end  
    class WrongParmatersException         < ServiceException; end
    class NoDomainException               < ServiceException; end
    class UnknownException                < ServiceException; end
  
    def self.raise_by_code(code)
      case code.to_i          
        when 400 
          raise DomainTools::BadRequestException
        when 401, 403
          raise DomainTools::NotAuthorizedException      
        when 404 
          raise DomainTools::NotFoundException
        when 500 
          raise DomainTools::InternalServerErrorException
        when 503 
          raise DomainTools::ServiceUnavailableException
        else 
          raise DomainTools::UnknownException
      end
    end
    
  end                          
end