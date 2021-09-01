require 'rails_helper'

describe Invitation, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:event_id) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'relationships' do
    it { should belong_to(:event) }
    it { should belong_to(:user) }
  end
end
