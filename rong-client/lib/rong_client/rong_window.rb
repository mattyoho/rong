require 'gosu'

module RongClient
  class RongWindow < Gosu::Window
    module ZIndex
      BACKGROUND = 0
      FOREGROUND = 1
    end

    WINDOW_WIDTH  = 640
    WINDOW_HEIGHT = 480
    WINDOW_CENTER_X = WINDOW_WIDTH / 2

    STRIPE_LEFT  = WINDOW_CENTER_X - 2
    STRIPE_RIGHT = WINDOW_CENTER_X + 2

    LEFT_PADDLE_X  = 120
    RIGHT_PADDLE_X = 520
    PADDLE_Y       = 240

    SCORE_FONT     = 'Krungthep'
    SCORE_HEIGHT   = 60
    SCORE_X_OFFSET = 40
    SCORE_Y_OFFSET = 20

    attr_accessor :paddles, :ball, :left_score, :right_score

    def initialize
      super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
      self.caption = "Rong: Ruby Pong"
      self.left_score = self.right_score = 0

      self.ball    = Ball.new(self, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
      self.paddles = [Paddle.new(self, LEFT_PADDLE_X,  PADDLE_Y),
                      Paddle.new(self, RIGHT_PADDLE_X, PADDLE_Y)]
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
      if button_down?(Gosu::Button::KbSpace)
        blip_file = File.join(File.dirname(__FILE__), '..', '..', 'assets', 'samples', 'pongblipG_5.wav')
        @blip = Gosu::Sample.new(self, blip_file)
        @blip.play(1,1)
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
      left_score_text  = left_score > 9  ? left_score.to_s  : "0#{left_score}"
      right_score_text = right_score > 9 ? right_score.to_s : "0#{right_score}"
      left_score_image  = Gosu::Image.from_text(self, left_score_text,  SCORE_FONT, SCORE_HEIGHT)
      right_score_image = Gosu::Image.from_text(self, right_score_text, SCORE_FONT, SCORE_HEIGHT)
      left_score_image.draw(WINDOW_CENTER_X - (SCORE_X_OFFSET + left_score_image.width), SCORE_Y_OFFSET, RongWindow::ZIndex::BACKGROUND)
      right_score_image.draw(WINDOW_CENTER_X + SCORE_X_OFFSET, SCORE_Y_OFFSET, RongWindow::ZIndex::BACKGROUND)
    end

    def button_down(id)
      if id == Gosu::Button::KbEscape
        close
      end
    end
  end

  module Entity
    attr_accessor :window, :x, :y

    def initialize(window, start_x, start_y)
      self.window = window
      self.x      = start_x
      self.y      = start_y
    end

    def draw
      window.draw_quad(x - self.class::WIDTH/2, y - self.class::HEIGHT/2, Gosu::Color::WHITE,
                       x - self.class::WIDTH/2, y + self.class::HEIGHT/2, Gosu::Color::WHITE,
                       x + self.class::WIDTH/2, y + self.class::HEIGHT/2, Gosu::Color::WHITE,
                       x + self.class::WIDTH/2, y - self.class::HEIGHT/2, Gosu::Color::WHITE,
                       RongWindow::ZIndex::FOREGROUND)
    end
  end

  class Ball
    WIDTH  = 6
    HEIGHT = 6
    include Entity

    def move

    end
  end

  class Paddle
    WIDTH  = 10
    HEIGHT = 40
    include Entity

    def move_up
      self.y -= (300 / 30)
    end

    def move_down
      self.y += (300 / 30)
    end
  end
end
