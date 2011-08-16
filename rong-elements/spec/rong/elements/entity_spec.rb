require 'spec_helper'

describe Rong::Elements::Entity do
  describe "#intersects?" do
    let(:entity) { Rong::Elements::Paddle.new('paddle', :left, 100, 100) }
    subject { entity.intersects?(other) }

    context "when no point is within the entity" do
      let(:other) { Rong::Elements::Ball.new(0, 0, 0) }
      it { should be_false }
    end

    context "when bottom left corner is within the entity" do
      let(:other) { Rong::Elements::Ball.new(103, 122, 0) }
      it { should be_true }
    end

    context "when top left corner is within the entity" do
      let(:other) { Rong::Elements::Ball.new(103, 76, 0) }
      it { should be_true }
    end

    context "when bottom right corner is within the entity" do
      let(:other) { Rong::Elements::Ball.new(98, 122, 0) }
      it { should be_true }
    end

    context "when top right corner is within the entity" do
      let(:other) { Rong::Elements::Ball.new(98, 76, 0) }
      it { should be_true }
    end

    context "when the elements overlap perfectly" do
      let(:other) { entity }
      it { should be_true }
    end
  end
end
