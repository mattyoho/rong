require 'spec_helper'

describe RongServer::Paddle do
  let(:paddle) { RongServer::Paddle.new(0) }
  it "can have a y-position" do
    paddle.y.should == 0
  end
end

