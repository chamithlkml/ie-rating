require 'rails_helper'

describe StatementEntry do
  statement_entry =
    StatementEntry.new(description: 'Test Income', amount: 1000, ie_statement: IeStatement.first, entry_type: :income)
  # Testing attribute validations for Income model
  describe 'validations' do
    # Valid with all required attributes
    it 'is valid with valid attributes' do
      expect(statement_entry).to be_valid
    end
    # Not valid without description attribute
    it 'is not valid without a description' do
      statement_entry.description = nil
      expect(statement_entry).to_not be_valid
    end
    # Not valid without amount attribute
    it 'is not valid without amount' do
      statement_entry.amount = nil
      expect(statement_entry).to_not be_valid
    end
    # Not valid without ie_statement_id attribute
    it 'is not valid without an ie_statement_id' do
      statement_entry.ie_statement = nil
      expect(statement_entry).to_not be_valid
    end
  end
  # Testing the association
  describe 'Associations' do
    it 'belongs to ie_statement' do
      relation = StatementEntry.reflect_on_association(:ie_statement)
      expect(relation.macro).to eq :belongs_to
    end
  end
end
