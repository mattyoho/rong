module Rong
  module Client
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
  end
end
