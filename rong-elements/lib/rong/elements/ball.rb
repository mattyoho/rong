module Rong
  module Elements
    class Ball
      attr_reader :x, :y

      def initialize(x=0, y=0)
        @x, @y = x, y
      end
    end
  end
end
