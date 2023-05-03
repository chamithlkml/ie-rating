class StatementEntry < ApplicationRecord
  include Discard::Model

  validates :description, :amount, :ie_statement_id, :entry_type, presence: true

  default_scope -> { kept }

  belongs_to :ie_statement

  enum :entry_type, { income: 0, expenditure: 1, debt_payment: 2 }, suffix: true, default: :income
end
