module Rong
  module Elements
    module Entities
      class Paddle
        attr_reader :velocity, :y

        def initialize(y_coord)
          @velocity = 0
          @y        = y_coord
        end

        def up
          @velocity =  1
        end

        def down
          @velocity = -1
        end

        def rest
          @velocity =  0
        end
      end
    end
  end
end
