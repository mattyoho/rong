module Rong
  module Server
    class Paddle
      attr_reader :y

      def initialize(y_coord)
        @y = y_coord
      end
    end
  end
end
