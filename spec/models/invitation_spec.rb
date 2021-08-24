require 'rails_helper'

describe Invitation, type: :model do
  describe 'validations' do
    # EDGE CASE: User can only be invited to a Viewing Party once
  end

  describe 'relationships' do
    it { should belong_to(:event) }
    it { should belong_to(:user) }
  end
end
