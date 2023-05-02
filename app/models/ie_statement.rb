class IeStatement < ApplicationRecord
  include Discard::Model

  validates :name, :user_id, presence: true

  default_scope -> { kept }

  belongs_to :user
  has_many :incomes
  has_many :expenditures
  has_many :debt_payments

end