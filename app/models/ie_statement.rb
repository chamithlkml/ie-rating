class IeStatement < ApplicationRecord
  include Discard::Model

  validates :name, :user_id, presence: true

  default_scope -> { kept }

  belongs_to :user
  has_many :statement_entries
end
