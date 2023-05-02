class Income < ApplicationRecord
  include Discard::Model

  validates :description, :amount, :ie_statement_id, presence: true

  default_scope -> { kept }

  belongs_to :ie_statement
end