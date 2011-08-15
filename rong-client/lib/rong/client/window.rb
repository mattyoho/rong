require 'gosu'
require 'rong/elements'

require 'rong/client/drawable_element'

module Rong
  module Client
    class Window < Gosu::Window
      include Rong::Elements::WindowConstants

      module ZIndex
        BACKGROUND = 0
        FOREGROUND = 1
        HUD = 2
      end

      STRIPE_LEFT  = WINDOW_CENTER_X - 2
      STRIPE_RIGHT = WINDOW_CENTER_X + 2

      SCORE_FONT     = 'Synchro LET'
      SCORE_HEIGHT   = 90
      SCORE_X_OFFSET = 40
      SCORE_Y_OFFSET = -10

      attr_accessor :game, :left_score_image, :right_score_image, :winner_image,
                    :paddle_boxes, :ball_box, :paddle_blip, :wall_blip

      def initialize
        super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
        self.caption = "Rong: Ruby Pong"

        self.game = Rong::Elements::Game.new do |g|
          g.on_score  {|left, right| update_scores(left, right) }
          g.on_hit    { paddle_blip.play }
          g.on_bounce { wall_blip.play }
          g.on_win    {|winner| create_winner_banner(winner) }
        end

        self.paddle_boxes = game.paddles.map {|p| DrawableElement.new(self, p) }
        self.ball_box     = DrawableElement.new(self, game.ball)

        self.left_score_image  = Gosu::Image.from_text(self, "00", SCORE_FONT, SCORE_HEIGHT)
        self.right_score_image = Gosu::Image.from_text(self, "00", SCORE_FONT, SCORE_HEIGHT)

        load_samples
      end

      def load_samples
        self.paddle_blip = Gosu::Sample.new(self, asset_sample('pongblipG_5.wav'))
        self.wall_blip   = Gosu::Sample.new(self, asset_sample('pongblipF5.wav'))
      end

      def asset_sample(file_name)
        File.join(File.dirname(__FILE__), '..', '..', '..', 'assets', 'samples', file_name)
      end

      def update
        if button_down?(Gosu::Button::KbA)
          game.paddles.first.move_up
        end
        if button_down?(Gosu::Button::KbZ)
          game.paddles.first.move_down
        end
        if button_down?(Gosu::Button::KbK)
          game.paddles.last.move_up
        end
        if button_down?(Gosu::Button::KbM)
          game.paddles.last.move_down
        end
        game.update
      end

      def draw
        draw_background
        paddle_boxes.each {|p| p.draw }
        ball_box.draw
        draw_winner_banner if winner?
      end

      def draw_background
        draw_stripe
        draw_scores
      end

      def draw_stripe
        (0..WINDOW_HEIGHT).step(20) do |y|
          draw_quad(STRIPE_LEFT,  y + 10, Gosu::Color::WHITE,
                    STRIPE_LEFT,  y, Gosu::Color::WHITE,
                    STRIPE_RIGHT, y, Gosu::Color::WHITE,
                    STRIPE_RIGHT, y + 10, Gosu::Color::WHITE,
                    Window::ZIndex::BACKGROUND)
        end
      end

      def draw_scores
        left_score_image.draw(WINDOW_CENTER_X - (SCORE_X_OFFSET + left_score_image.width), SCORE_Y_OFFSET, Window::ZIndex::BACKGROUND)
        right_score_image.draw(WINDOW_CENTER_X + SCORE_X_OFFSET, SCORE_Y_OFFSET, Window::ZIndex::BACKGROUND)
      end

      def create_winner_banner(winner)
        self.winner_image = Gosu::Image.from_text(self, "#{winner.name} wins!", SCORE_FONT, SCORE_HEIGHT)
      end

      def draw_winner_banner
        winner_image.draw(WINDOW_CENTER_X - (winner_image.width / 2), WINDOW_CENTER_Y, Window::ZIndex::HUD)
      end

      def winner?
        winner_image
      end

      def update_scores(left_score, right_score)
        left_score_text  = left_score  > 9 ? left_score.to_s  : "0#{left_score}"
        right_score_text = right_score > 9 ? right_score.to_s : "0#{right_score}"
        self.left_score_image  = Gosu::Image.from_text(self, left_score_text,  SCORE_FONT, SCORE_HEIGHT)
        self.right_score_image = Gosu::Image.from_text(self, right_score_text, SCORE_FONT, SCORE_HEIGHT)
      end

      def button_down(id)
        if id == Gosu::Button::KbEscape
          close
        elsif id == Gosu::Button::KbSpace && game.winner
          self.winner_image = nil
          game.reset
          update_scores(0, 0)
        end
      end
    end
  end
end
