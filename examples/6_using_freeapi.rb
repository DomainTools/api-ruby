# ----------------------------------------------------------------------------- 
# 6. USING THE FREE API
# -----------------------------------------------------------------------------

# 6.A Define settings
# This a a clear way to define each settings
DomainTools::use(DOMAINTOOLS_USERNAME,DOMAINTOOLS_KEY)
DomainTools::get("whois")
# Set the API type using the "with_api" method
DomainTools::with_api("free")
DomainTools::on("domaintools.com")

# 6.B All in one with a hash
# Useful to separate in a settings file your default configuration
DomainTools::with({
  :username   => DOMAINTOOLS_USERNAME,
  :key        => DOMAINTOOLS_KEY,
  :service    => "whois",
  :domain     => "domaintools.com",
  :api        => "free"
})     

# 1.C Inline
# Each call can be chained, useful in some case to gain space in your code
DomainTools::use(DOMAINTOOLS_USERNAME,DOMAINTOOLS_KEY)::get("whois")::as("json")::on("domaintools.com")::with_api("free")
# -----------------------------------------------------------------------------
# TIPS
# -----------------------------------------------------------------------------
# You can use "is_free?" on a request object to test if it is using the freeapi

request = DomainTools::get("whois")::as("json")::on("domaintools.com")::with_api("free").request
if request.is_free?
  puts "It's a free request!"
else
  puts "It's a standard request!"
end