require 'spec_helper'

describe Rong::Server::GameState do
  it "expects a list of paddle positions and a list ball positions" do
    expect do
      Rong::Server::GameState.new([0,1,3], [[1,2], [2,3]])
    end.to_not raise_error
  end

  context "paddle positions" do
    let(:game_state) { Rong::Server::GameState.new([0,1,3,4], [1,2]) }
    let(:positions)  { game_state.paddle_positions }

    it "makes them available through indexing" do
      positions[0].should == 0
      positions[1].should == 1
      positions[2].should == 3
      positions[3].should == 4
    end

    it "makes them assignable through indexing" do
      positions[1] = 654
      positions[1].should == 654
    end

    it "enumerates them" do
      game_state.first_paddle_position.should  == 0
      game_state.second_paddle_position.should == 1
      game_state.third_paddle_position.should  == 3
      game_state.fourth_paddle_position.should == 4
    end

    it "allows enumerated assignment" do
      game_state.second_paddle_position = 22
      game_state.second_paddle_position.should == 22
    end
  end

  describe "#ball_position" do
    context "when @ball_positions is an array of tuples" do
      let(:game_state) { Rong::Server::GameState.new([0,1], [[1,2], [3,2]]) }
      it "picks the first tuple" do
        game_state.ball_position.should == [1,2]
      end
    end

    context "when @ball_positions is a tuple" do
      let(:game_state) { Rong::Server::GameState.new([0,1], [1,2]) }
      it "returns the tuple" do
        game_state.ball_position.should == [1,2]
      end
    end
  end
end
