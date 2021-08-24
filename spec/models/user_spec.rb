require 'rails_helper'

describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe 'relationships' do
    it { should have_many(:events) }
    it { should have_many(:invitations) }
    it { should have_many(:followed_users).with_foreign_key('follower_id').class_name('Friendship') }
    it { should have_many(:followees).through(:followed_users) }
    it { should have_many(:following_users).with_foreign_key('followee_id').class_name('Friendship') }
    it { should have_many(:followers).through(:following_users) }
  end
end
