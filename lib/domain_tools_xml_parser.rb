module DomainToolsXmlParser
  class XMLParser          
    
    def self.parse(source)
      require 'rexml/document'
      doc = REXML::Document.new(source)
      root_node = doc.elements.first
      data_node = root_node.elements.first
      hash = self.parse_node({},data_node)
      puts "------------------------------------------------"
      puts hash.inspect                                      
      puts "------------------------------------------------"
      hash  
    end  
    
    def self.parse_node(hash,node)
      val = {}
      if node.has_elements?
        node.elements.each{|subnode| val = self.parse_node(val,subnode)}
      else
        val = node.text
      end 
      hash[node.name] = val
      hash
    end
    
  end
end