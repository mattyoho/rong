require 'spec_helper'

describe Rong::Server::Ball do
  let(:ball) { Rong::Server::Ball.new }

  context "initialization" do
    it "can set x and y" do
      ball = Rong::Server::Ball.new(12, 34)
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
