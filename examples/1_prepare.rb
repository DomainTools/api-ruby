# ----------------------------------------------------------------------------- 
# 1. PREPARE THE ENVIRONMENT
# -----------------------------------------------------------------------------

# 1.A Define settings step by step  
# This a a clear way to define each settings
DomainTools::use(DOMAINTOOLS_USERNAME,DOMAINTOOLS_KEY)
DomainTools::get("whois")
DomainTools::as("json")
DomainTools::on("domaintools.com")
DomainTools::where("var1=value1&var2=value2")

# 1.B All in one with a hash
# Useful to separate in a settings file your default configuration
DomainTools::with({
  :username   => DOMAINTOOLS_USERNAME,
  :key        => DOMAINTOOLS_KEY,         
  :service    => "whois",
  :format     => "json",
  :domain     => "domaintools.com",
  :parameters => "var1=value1&var2=value2"
})     

# 1.C Inline
# Each call can be chained, useful in some case to gain spaces in your code
DomainTools::use(DOMAINTOOLS_USERNAME,DOMAINTOOLS_KEY)
DomainTools::get("whois")::as("json")::on("domaintools.com")

# -----------------------------------------------------------------------------
# TIPS
# -----------------------------------------------------------------------------
# The parameters (set with the static call "where" or with the hash
# key "parameters") can either be a string or a Hash.
# If a hash is provided, it will be merged in a string before request execution
                   
# Using the "where" call to specify the parameters 
DomainTools::where({
  :var1 => "value1",
  :var2 => "value2"  
})

# Or using the "with" (hash) settiings method and the key "parameters"
DomainTools::with({
  # ...
  :parameters => {
    :var1 => "value1",
    :var2 => "value2"  
  }
})