module Rong
  module Elements
    module Entities
      class Ball
        attr_reader :x, :y

        def initialize(x=0, y=0)
          @x, @y = x, y
        end
      end
    end
  end
end
