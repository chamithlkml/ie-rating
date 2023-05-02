require 'rails_helper'

describe User do
  describe 'name' do
    it 'returns the full name of the user' do
      user = User.find(1)
      expect(user.name).to eq 'Tester'
    end
  end
end