# IeStatement Model
class IeStatement < ApplicationRecord
  include Discard::Model

  validates :name, :user_id, presence: true

  default_scope -> { kept }

  belongs_to :user
  has_many :statement_entries

  def income
    statement_entries.was_income.sum(:amount)
  end

  def expenditure
    statement_entries.was_expenditure.sum(:amount)
  end

  def debt_payment
    statement_entries.was_debt_payment.sum(:amount)
  end

  def total_expenditure
    expenditure + debt_payment
  end

  def disposable_income
    income - total_expenditure
  end

  def ie_ratio
    raise AppException.new 'Income cannot be 0' if income.zero?

    (total_expenditure / income.to_f) * 100
  end

  def ie_rating
    ie_ratio_calculated = ie_ratio
    case ie_ratio_calculated
    when ie_ratio_calculated < 10
      'A'
    when 10...30
      'B'
    when 30...50
      'C'
    else
      'D'
    end
  end
end
