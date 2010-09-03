require 'spec_helper'

describe Rong::Server::Game do
  let(:game) { Rong::Server::Game.new(800, 600) }

  context "initialization" do
    it "expects an x and y dimension" do
      expect { Rong::Server::Game.new     }.to raise_error(ArgumentError)
      expect { Rong::Server::Game.new(50) }.to raise_error(ArgumentError)

      expect { Rong::Server::Game.new(50, 50) }.to_not raise_error
    end

    it "accepts a GameState to set the ball and paddles" do
      game_state = Rong::Elements::Entities::GameState.new([123, 456], [789, 101])
      game       = Rong::Server::Game.new(0, 0, game_state)
      game.paddles.first.y.should == 123
      game.paddles.last.y.should  == 456
      game.ball.x.should          == 789
      game.ball.y.should          == 101
    end
  end

  context "the game state" do
    it "has 2 scores" do
      game.scores.should have(2).scores
    end

    it "has a ball" do
      game.ball.should be_a_kind_of(Rong::Elements::Entities::Ball)
    end

    context "the paddles" do
      it "exist as a pair" do
        game.paddles.should have(2).paddles
        game.paddles.first.should be_a_kind_of(Rong::Elements::Entities::Paddle)
        game.paddles.last.should  be_a_kind_of(Rong::Elements::Entities::Paddle)
      end
    end

    context "board dimensions" do
      it "has length" do
        game.board_length.should == 800
      end
      it "has height" do
        game.board_height.should == 600
      end
    end
  end

  context "game state updates" do

    describe "#add_listener" do
      it "accepts listeners for updates" do
        game.add_listener("listener_one")
        game.add_listener("listener_two")
        game.listeners.should include("listener_one")
        game.listeners.should include("listener_two")
      end
    end

    describe "#update_listeners" do
      it "sends a state update to all listeners" do
        listeners = [stub, stub].map do |s|
          s.should_receive(:update_game_state)
          game.add_listener s
          s
        end

        game.update_listeners
      end

      it "sends current_game_state in the update" do
        game.stub(:current_game_state => 'the game state')

        listener = stub
        listener.should_receive(:update_game_state).with('the game state')
        game.add_listener(listener)

        game.update_listeners
      end
    end

    describe "#current_game_state" do
      it "returns a GameState with the current state" do
        expected = Rong::Elements::Entities::GameState.new([20, 40], [42, 1337])
        current  = Rong::Server::Game.new(0, 0, expected).current_game_state
        current.first_paddle_position.should  == 20
        current.second_paddle_position.should == 40
        current.ball_position.should == [42, 1337]
      end
    end
  end
end
