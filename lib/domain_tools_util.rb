module DomainToolsUtil
  class Util
    
    # convert a Hash into inline string for GET params
    def self.vars_hash_to_string(hash)    
      vars = Array.new
      hash.each {|key, value| vars.push key.to_s+"="+value.to_s}
      '&'+vars.join('&')
    end
    
  end
end