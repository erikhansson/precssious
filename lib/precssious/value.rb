
module Precssious
  
  Value = Struct.new :rule

  class Value
    def to_s
      "#{rule};"
    end
  end
  
end