require 'gosu'
WINDOW_WIDTH  = 640
WINDOW_HEIGHT = 480
WINDOW_CENTER_X = WINDOW_WIDTH  / 2
WINDOW_CENTER_Y = WINDOW_HEIGHT / 2

LEFT_PADDLE_X  = 100
RIGHT_PADDLE_X = 540
PADDLE_Y       = 240

SERVE_FROM_X  = WINDOW_CENTER_X
SERVE_FROM_Y  = WINDOW_CENTER_Y - 210

module Rong
  module Client
    class Game
      WINNING_SCORE = 12

      attr_accessor :paddles, :ball, :winner,
        :left_score, :right_score,
        :score_callbacks,  :hit_callbacks,
        :bounce_callbacks, :win_callbacks

      def initialize
        self.left_score = self.right_score = 0

        self.score_callbacks  = []
        self.hit_callbacks    = []
        self.bounce_callbacks = []
        self.win_callbacks    = []

        self.ball    = Ball.new(WINDOW_CENTER_X, WINDOW_CENTER_Y, 0)
        self.paddles = [Paddle.new("Player 1", LEFT_PADDLE_X,  PADDLE_Y),
          Paddle.new("Player 2", RIGHT_PADDLE_X, PADDLE_Y)]
      end

      def update
        return if winner
        ball.move
        paddles.each {|p| check_bounds(p) }
        check_ball_bounds
        check_win_condition
        paddles.each do |paddle|
          if paddle.intersects?(ball)
            paddle.hit(ball)
            hit
          end
        end
      end

      def reset
        self.winner     = nil
        self.left_score = self.right_score = 0
        reset_paddles
        ball.serve_from(SERVE_FROM_X, SERVE_FROM_Y)
      end

      def on_score(&block)
        score_callbacks << block if block_given?
      end

      def score
        score_callbacks.each {|cb| cb.call(left_score, right_score) }
      end

      def on_hit(&block)
        hit_callbacks << block if block_given?
      end

      def hit
        hit_callbacks.each {|cb| cb.call }
      end

      def on_bounce(&block)
        bounce_callbacks << block if block_given?
      end

      def bounce
        bounce_callbacks.each {|cb| cb.call }
      end

      def on_win(&block)
        win_callbacks << block if block_given?
      end

      def reset_paddles
        paddles.first.move_to(LEFT_PADDLE_X,  PADDLE_Y)
        paddles.last.move_to(RIGHT_PADDLE_X,  PADDLE_Y)
      end

      def declare_winner(who)
        ball.move_to(WINDOW_CENTER_X, WINDOW_CENTER_Y)
        ball.stop
        self.winner = who
        win_callbacks.each {|cb| cb.call(who) }
      end

      def check_bounds(entity)
        if entity.top < 0
          entity.move_to(entity.x, 0 + entity.height / 2)
        end
        if entity.bottom > WINDOW_HEIGHT
          entity.move_to(entity.x, WINDOW_HEIGHT - entity.height / 2)
        end
      end

      def check_ball_bounds
        if ball.top < 0 || ball.bottom > WINDOW_HEIGHT
          bounce
          ball.reflect_y
        end

        if ball.left < 0 || ball.right > WINDOW_WIDTH
          if ball.left < 0
            self.left_score += 1
            ball.serve_right_from(SERVE_FROM_X, SERVE_FROM_Y)
          else
            self.right_score += 1
            ball.serve_left_from(SERVE_FROM_X, SERVE_FROM_Y)
          end
          score
          reset_paddles
        end
      end

      def check_win_condition
        if left_score >= WINNING_SCORE
          declare_winner(paddles.first)
        elsif right_score >= WINNING_SCORE
          declare_winner(paddles.last)
        end
      end
    end

    class Window < Gosu::Window
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

        self.game = Game.new
        game.on_score  {|left, right| update_scores(left, right) }
        game.on_hit    { paddle_blip.play(1,1) }
        game.on_bounce { wall_blip.play(1,1) }
        game.on_win do |winner|
          self.winner_image = Gosu::Image.from_text(self, "#{winner.name} wins!", SCORE_FONT, SCORE_HEIGHT)
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
        if winner_image
          winner_image.draw(WINDOW_CENTER_X - (winner_image.width / 2), WINDOW_CENTER_Y, Window::ZIndex::HUD)
        end
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

    class DrawableElement
      attr_reader :color, :element, :window, :z_index

      def initialize(window, element, color = Gosu::Color::WHITE, z_index = Window::ZIndex::FOREGROUND)
        @window  = window
        @element = element
        @color   = color
        @z_index = z_index
      end

      def draw
        window.draw_quad(element.left,  element.top,    color,
                         element.left,  element.bottom, color,
                         element.right, element.bottom, color,
                         element.right, element.top,    color,
                         z_index)
      end

    end

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
        if other.left < right && other.left > left
          if other.bottom < bottom && other.bottom > top
            true
          elsif other.top > top && other.top < bottom
            true
          else
            false
          end
        elsif other.right > left && other.right < right
          if other.bottom < bottom && other.bottom > top
            true
          elsif other.top > top && other.top < bottom
            true
          else
            false
          end
        else
          false
        end
      end
    end

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

      def reflect_x
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
