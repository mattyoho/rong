require 'rong/elements/entities'

module Rong
  module Server
    class Game
      attr_reader :ball,
                  :board_height,
                  :board_length,
                  :listeners,
                  :paddles,
                  :scores

      def initialize(length, height, state=Rong::Elements::Entities::GameState.new)
        @ball         = Rong::Elements::Entities::Ball.new(state.ball_position.first, state.ball_position.last)
        @board_length = length
        @board_height = height
        @paddles      = [Rong::Elements::Entities::Paddle.new(state.first_paddle_position), Rong::Elements::Entities::Paddle.new(state.second_paddle_position)]
        @scores       = [0, 0]
        @listeners    = []
        @game_state   = state
      end

      def add_listener(listener)
        @listeners << listener
      end

      def current_game_state
        @game_state
      end

      def update_listeners
        listeners.each do |l|
          l.update_game_state(current_game_state)
        end
      end

    end
  end
end
