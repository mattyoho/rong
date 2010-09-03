require 'spec_helper'

describe Rong::Elements::Entities::Ball do
  let(:ball) { Rong::Elements::Entities::Ball.new }

  context "initialization" do
    it "can set x and y" do
      ball = Rong::Elements::Entities::Ball.new(12, 34)
      ball.x.should == 12
      ball.y.should == 34
    end

    context "defaults" do
      it "x is 0" do
        ball.x.should == 0
      end
      it "y is 0" do
        ball.y.should == 0
      end
    end
  end
end
