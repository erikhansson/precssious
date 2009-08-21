
module Precssious

  class Preprocessor
  
    def initialize(input)
      @tokens = []
      
      Preprocessor.tokenize(Preprocessor.strip_comments(input)) do |t|
        @tokens << t
      end
    end
  
  
    def pull(type = nil) 
      result = @tokens.shift
      if type && result.type != type
        raise 'Unexpected token (#{result}, #{@tokens[0]}, #{@tokens[1]}, #{@tokens[2]}, #{@tokens[3]})' 
      end
      result
    end
    def peek; @tokens[0]; end
    def peek2; @tokens[1] if @tokens.length > 1; end
    def consume(type)
      t = pull
      if t.type != type
        raise "Unexpected token (#{t.data}, #{@tokens[0]}, #{@tokens[1]}, #{@tokens[2]}, #{@tokens[3]}) #{t.type}, expected #{type}"  
      end
    end
  
  
    def rules
      result = []
      while peek
        result << rule
      end
      result
    end
  
    def rule
      Rule.new pull(:text).data, rule_value
    end
  
    def rule_value
      consume :lbrace
      result = any
      consume :rbrace
      result
    end
  
    def any
      result = []
      while (peek.type != :rbrace)
        if peek2 && peek2.type == :lbrace
          result << rule 
        else
          if peek2 && peek2.type == :semicolon
            result << value 
          else
            raise 'Unexpected CSS syntax (missing ;?)'
          end
        end
      end
      result
    end
  
    def value
      l = pull(:text)
      consume(:semicolon)
      Value.new l.data
    end
  
    def self.tokenize(input)
      current = []
      input.each_char do |c|
        if %W({ } ;).include? c.to_s
          prev = current.join('').strip
          current.clear

          yield Token.new(:text, prev) if prev.length > 0
          yield Token.new(:lbrace, nil) if c.to_s == '{'
          yield Token.new(:rbrace, nil) if c.to_s == '}'
          yield Token.new(:semicolon, nil) if c.to_s == ';'
        else
          current << c
        end
      end
    end
    
    def self.strip_comments(input)
      input.gsub /\/\*.*?\*\//, ''
    end
    
  end
end
