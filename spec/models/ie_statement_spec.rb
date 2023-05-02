require 'rails_helper'

describe IeStatement do
  ie_statement = IeStatement.new(name: 'Test Statement', user: User.first)
  #Testing model attribute validations
  describe 'validations' do
    # Valid with all required attributes
    it 'is valid with valid attributes' do
      expect(ie_statement).to be_valid
    end
    # Not valid without name attribute
    it 'is not valid without a name' do
      ie_statement.name = nil
      expect(ie_statement).to_not be_valid
    end
    # Not valid without user_id attribute
    it 'is not valid without a user' do
      ie_statement.user = nil
      expect(ie_statement).to_not be_valid
    end
  end
  # Testing the association
  describe 'Associations' do
    it 'belongs to users' do
      relation = IeStatement.reflect_on_association(:user)
      expect(relation.macro).to eq :belongs_to
    end
  end
end
