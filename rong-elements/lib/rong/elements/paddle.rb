module Rong
  module Elements
    class Paddle
      WIDTH  = 10
      HEIGHT = 50
      SPEED  = 10
      include Entity

      attr_accessor :name, :side

      def initialize(name, side, start_x, start_y)
        self.name = name
        self.side = side
        super(start_x, start_y)
      end

      def move_up
        self.y -= SPEED
      end

      def move_down
        self.y += SPEED
      end

      def left?
        side == :left
      end

      def hit(ball)
        ball_x = left? ? right : left
        ball.reflect_x(ball_x)
        ball.reflect_y if ball.y < y

        strength = (y - ball.y).abs / (height / 2)
        ball.angle = 45 * strength
      end
    end
  end
end
