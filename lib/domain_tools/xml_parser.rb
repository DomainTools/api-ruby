module DomainTools
  class XMLParser          
    
    def self.parse(source)
      require 'rexml/document'
      doc = REXML::Document.new(source)
      root_node = doc.elements.first
      data_node = root_node.elements.first
      hash = self.parse_node({},data_node)
    end  
    
    def self.parse_node(hash,node)
      val = {}
      if node.has_elements?
        node.elements.each{|subnode| val = self.parse_node(val,subnode)}
      else
        val = node.text
      end
      if hash[node.name].kind_of?(Array)
        hash[node.name] << val 
      elsif !hash[node.name].nil?
        tmp = hash[node.name]
        hash[node.name] = [tmp,val]
      else
        hash[node.name] = val
      end      
      hash
    end
    
  end
end