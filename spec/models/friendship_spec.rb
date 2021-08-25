require 'rails_helper'

describe Friendship, type: :model do
  describe 'validations' do
    # EDGE CASE: Follower can only follow Followee once
  end

  describe 'relationships' do
    it { should belong_to(:follower).class_name('User') }
    it { should belong_to(:followee).class_name('User') }
  end
end
