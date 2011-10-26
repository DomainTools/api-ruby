# -----------------------------------------------------------------------------
# 3. BROWSE AN API RESPONSE
# -----------------------------------------------------------------------------
# Note: each of these examples assume that "prepare" step (see example 1.)
# has been done with valid credentials


# 3.A The "do it yourself" way
# get the raw result (json)
request         = DomainTools.request
request.format  = "json" # (or xml)
response        = request.response
# Use JSON.decode to parse the result (REXML for xml, for example)
hash            = ActiveSupport::JSON.decode(response.content)    
# Simply use it as a Hash
@example1       = hash["response"]["registration"]["registrar"]
                         

# 3.B The "auto parse" way
# get the response (without even knowing the request format!)
response  = DomainTools.request.response
# The DomainTools wrapper will parse the result automaticaly
# You can now use to_hash method to get a hash and use it
@example2 = response.to_hash["response"]["registration"]["registrar"]


# 3.C The short way, inline
# Like always, you can do this inline!
@example3 = DomainTools.request.do["response"]["registration"]["registrar"]


# -----------------------------------------------------------------------------
# TIPS
# -----------------------------------------------------------------------------
# Using the direct browsing of the hash assumes you are sure of the response
# structure. Some tests for nil values can be useful!  