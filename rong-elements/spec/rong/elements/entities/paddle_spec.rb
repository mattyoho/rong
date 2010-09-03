require 'spec_helper'

describe Rong::Elements::Entities::Paddle do
  let(:paddle) { Rong::Elements::Entities::Paddle.new(0) }
  it "can have a y-position" do
    paddle.y.should == 0
  end
  
  describe "y-velocity" do
    it "is zero by default" do
      paddle.velocity.should be_zero
    end
  end

  describe "direction" do
    it "can be told to move up" do
      paddle.up
      paddle.velocity.should > 0
    end

    it "can be told to move down" do
      paddle.down
      paddle.velocity.should < 0
    end

    it "can be told to rest" do
      paddle.down
      paddle.rest
      paddle.velocity.should == 0
    end
  end
end
