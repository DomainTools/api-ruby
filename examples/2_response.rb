# -----------------------------------------------------------------------------
# 2. GET RAW API RESULT (JSON, XML or HTML)
# -----------------------------------------------------------------------------
# Note: each of these examples assume that "prepare" step (see example 1.)
# has been done with valid credentials


# 2.A The "step by step" way
request         = DomainTools.request   # Get a request object
request.format  = "json" #xml,html      # Define the response format
request.domain  = "domaintools.com"     # Define the domain
response        = request.do            # Execute the request
@example1       = response.to_s         # Save the raw result in a variable

# 2.B You can do the same but inline
@example2       = DomainTools::as("json")::on("domaintools.com").do.to_s

# -----------------------------------------------------------------------------
# TIPS
# -----------------------------------------------------------------------------
# There are aliases for each method on each DomainTools related object.
# It allows you to use great shortcuts to quickly write requests

# Here is 3 line doing exactly the same thing :
# - Create a request (with default settings provided)
# - Execute the request
# - Return a Response object

@example3       = DomainTools.request.response 
@example4       = DomainTools.request.do
@example5       = DomainTools.do