require 'rails_helper'

describe Income do
  income = Income.new(description: 'Test Income', amount: 1000, ie_statement: IeStatement.first)
  # Testing attribute validations for Income model
  describe 'validations' do
    # Valid with all required attributes
    it 'is valid with valid attributes' do
      expect(income).to be_valid
    end
    # Not valid without description attribute
    it 'is not valid without a description' do
      income.description = nil
      expect(income).to_not be_valid
    end
    # Not valid without amount attribute
    it 'is not valid without amount' do
      income.amount = nil
      expect(income).to_not be_valid
    end
    # Not valid without ie_statement_id attribute
    it 'is not valid without an ie_statement_id' do
      income.ie_statement = nil
      expect(income).to_not be_valid
    end
  end
  # Testing the association
  describe 'Associations' do
    it 'belongs to ie_statement' do
      relation = Income.reflect_on_association(:ie_statement)
      expect(relation.macro).to eq :belongs_to
    end
  end
end
