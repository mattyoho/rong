module Rong
  module Elements
    class GameState
      attr_reader :paddle_positions, :ball_positions

      def initialize(paddle_positions=[0,0], ball_positions=[0,0])
        @ball_positions    = ball_positions
        @paddle_positions  = paddle_positions
      end

      %w(first second third fourth).each_with_index do |ordinal, index|
        define_method("#{ordinal}_paddle_position") do
          @paddle_positions[index]
        end

        define_method("#{ordinal}_paddle_position=") do |value|
          @paddle_positions[index] = value
        end
      end

      def ball_position
        position = ball_positions.first
        return position if position.kind_of? Array
        ball_positions
      end
    end
  end
end
