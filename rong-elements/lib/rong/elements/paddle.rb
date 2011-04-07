module Rong
  module Elements
    class Paddle
      WIDTH  = 10
      HEIGHT = 50
      SPEED  = 10
      include Entity

      attr_accessor :name

      def initialize(name, start_x, start_y)
        self.name = name
        super(start_x, start_y)
      end

      def move_up
        self.y -= SPEED
      end

      def move_down
        self.y += SPEED
      end

      def hit(ball)
        ball.reflect_x
        if ball.y < y
          ball.reflect_y
        end

        strength = (y - ball.y).abs / (height / 2)
        ball.angle = 45 * strength
      end
    end
  end
end
