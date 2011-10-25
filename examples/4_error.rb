# -----------------------------------------------------------------------------
# 4. ERROR HANDLING
# -----------------------------------------------------------------------------
# Note: each of these examples assume that "prepare" step (see example 1.)
# has been done with valid credentials

# 4.A When you execute a request, it can raise an exception, you need
# to be ready to catch it.
begin
  request         = DomainTools.request
  request.domain  = "domaintoolscom"          # This is not a valid domain
  request.response                            # Execute the request
  # here an execption will be thrown, we'll fallback to the rescue part
  @example1       = "I will never be seen"
rescue DomainTools::ServiceException => e
  if request.error?                           # test if there is an error
    @example1 = "#{e.class}: #{request.error}"
    # you can also get the error code with  request.error.code
    # and the error message with            request.error.message
  else
    @example1 = "The request has no error but raises an exception. Unlikely to hapenned"
  end
end                                    

# ----------------------------------------------------------------------------- 
# TIPS
# -----------------------------------------------------------------------------
# Here is the list of possible exceptions (and their inheritance)

# ServiceException                < StandardError
# NoSettingsException             < ServiceException
# NoCredentialsException          < ServiceException
# BadRequestException             < ServiceException
# NotAuthorizedException          < ServiceException
# NotFoundException               < ServiceException
# InternalServerErrorException    < ServiceException
# ServiceUnavailableException     < ServiceException
# WrongParmatersException         < ServiceException
# NoDomainException               < ServiceException
# UnknownException                < ServiceException