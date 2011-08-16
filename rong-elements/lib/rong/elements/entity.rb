module Rong
  module Elements
    module Entity
      attr_accessor :x, :y
      attr_reader   :height, :width

      def initialize(start_x, start_y)
        self.x      = start_x
        self.y      = start_y
        @height = self.class::HEIGHT
        @width  = self.class::WIDTH
      end

      def move_to(x, y)
        self.x = x
        self.y = y
      end

      def top
        y - height / 2
      end

      def bottom
        y + height / 2
      end

      def left
        x - width / 2
      end

      def right
        x + width / 2
      end

      def intersects?(other)
        if left > other.right
          return false
        end
        if right < other.left
          return false
        end
        if top > other.bottom
          return false
        end
        if bottom < other.top
          return false
        end
        true
      end
    end
  end
end
