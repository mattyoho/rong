require 'rong/elements/entity'

module Rong
  module Elements
    class Ball
      WIDTH  = 8
      HEIGHT = 8
      SPEED  = 10
      include Entity

      attr_accessor :angle, :x_direction, :y_direction

      def initialize(start_x, start_y, angle)
        self.angle = angle
        self.x_direction = self.y_direction = 1
        super(start_x, start_y)
      end

      def reflect_x(x_position=nil)
        move_to(x_position, y) if x_position
        self.x_direction *= -1
      end

      def reflect_y
        self.y_direction *= -1
      end

      def move
        self.x += SPEED * Math.cos(angle_radians) * x_direction
        self.y += SPEED * Math.sin(angle_radians) * y_direction
      end

      def stop
        self.x_direction = self.y_direction = 0
      end

      def serve_left_from(x, y)
        move_to(x, y)
        self.y_direction = 1
        self.x_direction = -1
        self.angle = 45
      end

      def serve_right_from(x, y)
        move_to(x, y)
        self.y_direction = 1
        self.x_direction = 1
        self.angle = 45
      end

      def serve_from(x, y)
        rand(2) == 1 ? serve_right_from(x, y) : serve_left_from(x, y)
      end

      protected
      def angle_radians
        angle * (Math::PI / 180)
      end
    end
  end
end
