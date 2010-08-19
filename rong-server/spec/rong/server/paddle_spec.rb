require 'spec_helper'

describe Rong::Server::Paddle do
  let(:paddle) { Rong::Server::Paddle.new(0) }
  it "can have a y-position" do
    paddle.y.should == 0
  end
end
