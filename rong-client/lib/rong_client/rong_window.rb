require 'gosu'

module RongClient
  class RongWindow < Gosu::Window
    module ZIndex
      BACKGROUND = 0
      FOREGROUND = 1
      HUD = 2
    end

    WINDOW_WIDTH  = 640
    WINDOW_HEIGHT = 480
    WINDOW_CENTER_X = WINDOW_WIDTH / 2

    STRIPE_LEFT  = WINDOW_CENTER_X - 2
    STRIPE_RIGHT = WINDOW_CENTER_X + 2

    LEFT_PADDLE_X  = 100
    RIGHT_PADDLE_X = 540
    PADDLE_Y       = 240

    SCORE_FONT     = 'Krungthep'
    SCORE_HEIGHT   = 60
    SCORE_X_OFFSET = 40
    SCORE_Y_OFFSET = 20

    attr_accessor :paddles, :ball, :left_score, :right_score,
                  :left_score_image, :right_score_image, :paddle_blip, :wall_blip

    def initialize
      super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
      self.caption = "Rong: Ruby Pong"
      self.left_score = self.right_score = 0

      self.ball    = Ball.new(self, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 0)
      self.paddles = [Paddle.new(self, LEFT_PADDLE_X,  PADDLE_Y),
                      Paddle.new(self, RIGHT_PADDLE_X, PADDLE_Y)]
      self.left_score_image  = Gosu::Image.from_text(self, "00", SCORE_FONT, SCORE_HEIGHT)
      self.right_score_image = Gosu::Image.from_text(self, "00", SCORE_FONT, SCORE_HEIGHT)

      load_samples
    end

    def load_samples
      blip_file = File.join(File.dirname(__FILE__), '..', '..', 'assets', 'samples', 'pongblipG_5.wav')
      self.paddle_blip = Gosu::Sample.new(self, blip_file)

      blip_file = File.join(File.dirname(__FILE__), '..', '..', 'assets', 'samples', 'pongblipF5.wav')
      self.wall_blip = Gosu::Sample.new(self, blip_file)
    end

    def update
      if button_down?(Gosu::Button::KbA)
        paddles.first.move_up
      end
      if button_down?(Gosu::Button::KbZ)
        paddles.first.move_down
      end
      if button_down?(Gosu::Button::KbK)
        paddles.last.move_up
      end
      if button_down?(Gosu::Button::KbM)
        paddles.last.move_down
      end
      ball.move
      paddles.each {|p| check_bounds(p) }
      check_ball_bounds
      paddles.each do |paddle|
        if paddle.intersects?(ball)
          paddle.hit(ball)
          paddle_blip.play(1,1)
        end
      end
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
        wall_blip.play(1,1)
        ball.reflect_y
      end

      if ball.left < 0
        self.left_score += 1
        update_scores
        ball.reflect_x
      elsif ball.right > WINDOW_WIDTH
        self.right_score += 1
        update_scores
        ball.reflect_x
      end
    end

    def draw
      draw_background
      paddles.each {|p| p.draw }
      ball.draw
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
                RongWindow::ZIndex::BACKGROUND)
      end
    end

    def draw_scores
      left_score_image.draw(WINDOW_CENTER_X - (SCORE_X_OFFSET + left_score_image.width), SCORE_Y_OFFSET, RongWindow::ZIndex::BACKGROUND)
      right_score_image.draw(WINDOW_CENTER_X + SCORE_X_OFFSET, SCORE_Y_OFFSET, RongWindow::ZIndex::BACKGROUND)
    end

    def update_scores
      left_score_text  = left_score  > 9 ? left_score.to_s  : "0#{left_score}"
      right_score_text = right_score > 9 ? right_score.to_s : "0#{right_score}"
      self.left_score_image  = Gosu::Image.from_text(self, left_score_text,  SCORE_FONT, SCORE_HEIGHT)
      self.right_score_image = Gosu::Image.from_text(self, right_score_text, SCORE_FONT, SCORE_HEIGHT)
    end

    def button_down(id)
      if id == Gosu::Button::KbEscape
        close
      end
    end
  end

  module Entity
    attr_accessor :window, :x, :y
    attr_reader   :height, :width

    def initialize(window, start_x, start_y)
      self.window = window
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

    def draw
      window.draw_quad(left,  top,    Gosu::Color::WHITE,
                       left,  bottom, Gosu::Color::WHITE,
                       right, bottom, Gosu::Color::WHITE,
                       right, top,    Gosu::Color::WHITE,
                       RongWindow::ZIndex::FOREGROUND)
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

    attr_accessor :angle
    attr_reader   :x_direction, :y_direction

    def initialize(window, start_x, start_y, angle=90)
      self.angle = angle
      @x_direction = @y_direction = 1
      super(window, start_x, start_y)
    end

    def angle_radians
      angle * (Math::PI / 180)
    end

    def reflect_x
      @x_direction *= -1
    end

    def reflect_y
      @y_direction *= -1
    end

    def move
      self.x += SPEED * Math.cos(angle_radians) * x_direction
      self.y += SPEED * Math.sin(angle_radians) * y_direction
    end
  end

  class Paddle
    WIDTH  = 10
    HEIGHT = 50
    SPEED  = 10
    include Entity

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

      ball.angle = rand(46)
    end
  end
end
