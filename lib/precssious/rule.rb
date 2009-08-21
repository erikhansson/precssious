
module Precssious
  
  Rule = Struct.new :selector, :values

  class Rule
    def to_s(context = nil)
      @context = context
      r, v = values.partition { |x| Rule === x }
    
      result = []
      result << "#{selector_string} { #{v.map { |x| x.to_s }.join ' '} }" if v.length > 0
      
      r.each do |nested|
        result << nested.to_s(self)
      end
    
      result.join "\n"
    end
  
    def is_hack?
      raw_selector_string =~ /\[[a-z0-9]*\]/
    end
    
    def selector_string
      raw_selector_string.gsub /\[[a-z0-9]*\] /, ''
    end
    
    def raw_selector_string
      selectors.join(', ').gsub(/\s+-/, '')
    end
    
    def selectors
      reverse, current = selector.split(',').map { |x| x.strip }.partition { |s| s =~ /<>/ }
    
      return current unless @context
    
      result = []
    
      @context.selectors.map do |cs|
        current.map { |s| result << "#{cs} #{s}" }
      end
      reverse.map do |rs|
        @context.selectors.map { |cs| result << "#{rs.gsub('<>', '').strip} #{cs}" }
      end
    
      result
    end
  end
  
end