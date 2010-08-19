require 'spec_helper'

describe Rong::Server::Base do
  let(:base) { Rong::Server::Base.new(800, 600) }

  context "initialization" do
    it "expects an x and y dimension" do
      expect { Rong::Server::Base.new     }.to raise_error(ArgumentError)
      expect { Rong::Server::Base.new(50) }.to raise_error(ArgumentError)

      expect { Rong::Server::Base.new(50, 50) }.to_not raise_error
    end

    it "accepts a GameState to set the ball and paddles" do
      game_state = Rong::Server::GameState.new(123, 456, [789, 101])
      base       = Rong::Server::Base.new(0, 0, game_state)
      base.paddles.first.y.should == 123
      base.paddles.last.y.should  == 456
      base.ball.x.should          == 789
      base.ball.y.should          == 101
    end
  end

  context "the game state" do
    it "has 2 scores" do
      base.scores.should have(2).scores
    end

    it "has a ball" do
      base.ball.should be_a_kind_of(Rong::Server::Ball)
    end

    context "the paddles" do
      it "exist as a pair" do
        base.paddles.should have(2).paddles
        base.paddles.first.should be_a_kind_of(Rong::Server::Paddle)
        base.paddles.last.should  be_a_kind_of(Rong::Server::Paddle)
      end
    end

    context "board dimensions" do
      it "has length" do
        base.board_length.should == 800
      end
      it "has height" do
        base.board_height.should == 600
      end
    end
  end

  context "game state updates" do

    describe "#add_listener" do
      it "accepts listeners for updates" do
        base.add_listener("listener_one")
        base.add_listener("listener_two")
        base.listeners.should include("listener_one")
        base.listeners.should include("listener_two")
      end
    end

    describe "#update_listeners" do
      it "sends a state update to all listeners" do
        listeners = [stub, stub].map do |s|
          s.should_receive(:update_game_state)
          base.add_listener s
          s
        end

        base.update_listeners
      end

      it "sends current_game_state in the update" do
        base.stub(:current_game_state => 'the game state')

        listener = stub
        listener.should_receive(:update_game_state).with('the game state')
        base.add_listener(listener)

        base.update_listeners
      end
    end

    describe "#current_game_state" do
      it "returns a GameState with the current state" do
        expected = Rong::Server::GameState.new(20, 40, [42, 1337])
        current  = Rong::Server::Base.new(0, 0, expected).current_game_state
        current.paddle1_y.should   == 20
        current.paddle2_y.should   == 40
        current.ball_coords.should == [42, 1337]
      end
    end
  end
end
