require 'rails_helper'

describe Expenditure do
  expenditure = Expenditure.new(description: 'Test Expenditure', amount: 100, ie_statement: IeStatement.first)
  # Testing attribute validations for Income model
  describe 'validations' do
    # Valid with all required attributes
    it 'is valid with valid attributes' do
      expect(expenditure).to be_valid
    end
    # Not valid without description attribute
    it 'is not valid without a description' do
      expenditure.description = nil
      expect(expenditure).to_not be_valid
    end
    # Not valid without amount attribute
    it 'is not valid without amount' do
      expenditure.amount = nil
      expect(expenditure).to_not be_valid
    end
    # Not valid without ie_statement_id attribute
    it 'is not valid without an ie_statement_id' do
      expenditure.ie_statement = nil
      expect(expenditure).to_not be_valid
    end
  end
  # Testing the association
  describe 'Associations' do
    it 'belongs to ie_statement' do
      relation = Expenditure.reflect_on_association(:ie_statement)
      expect(relation.macro).to eq :belongs_to
    end
  end
end
