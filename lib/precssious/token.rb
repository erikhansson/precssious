
module Precssious

  Token = Struct.new :type, :data

  class Token
    def to_s
      type == :text ? "[#{data}]" : ":#{type}"
    end
  end
  
end
