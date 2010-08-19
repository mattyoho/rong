module Rong
  module Server
    class GameState
      attr_accessor :paddle1_y, :paddle2_y, :ball_coords

      def initialize(paddle1_y=0, paddle2_y=0, ball_coords=[0,0])
        @paddle1_y  = paddle1_y
        @paddle2_y  = paddle2_y
        @ball_coords = ball_coords
      end
    end
  end
end
