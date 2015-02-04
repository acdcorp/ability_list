require File.expand_path('../helper.rb', __FILE__)

module ColumnTest
  Video  = Class.new(OpenStruct)
  Player = Class.new(OpenStruct)

  # ---

  class User < OpenStruct
    include AbilityList::Helpers

    def abilities
      @abilities ||= Abilities.new(self)
    end
  end

  # ---

  class Abilities < AbilityList
    def initialize(user)
      # Every can view videos.
      can :view, Video, [:title, :description]
      can :view, Player, :name
    end
  end

  # ---

  describe 'Column tests' do
    it '#can? 1' do
      user   = User.new
      video  = Video.new title: 'moo', description: 'cow', about: 'grass'
      player = Player.new name: 'Bob', age: 100

      user.can?(:view, video, :title).must_equal true
      user.can?(:view, video, [:title, :description]).must_equal true
      user.can?(:view, video, :about).must_equal false
      user.can?(:view, player, :name).must_equal true
      user.cannot?(:view, player, :age).must_equal true
      user.cannot?(:view, player, :name).must_equal false
    end
  end
end
