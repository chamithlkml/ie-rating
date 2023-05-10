class IeStatementsController < ApplicationController
  def new
    @ie_statement = IeStatement.new

    render
  end

  def create
    ie_statement = IeStatement.new(ie_statement_params)
    ie_statement.user = current_user
    ie_statement.save!
    save_statement_entries(ie_statement, :income)
    save_statement_entries(ie_statement, :expenditure)
    save_statement_entries(ie_statement, :debt_payment)
    render json: json_response(ie_statement, 'Your Income/Expenditure statement is added!')
  end

  def index
    render json: {
      success: true,
      ie_statements: current_user.ie_statements
    }
  end

  def show
    found_ie_statement_id = current_user.ie_statements.where(id: params[:id]).first.try(:id)
    raise AppException.new 'Statement not found' if found_ie_statement_id.nil?

    ie_statement = IeStatement.find(found_ie_statement_id)
    render json: json_response(ie_statement)
  end

  private

  def json_response(ie_statement, message = '')
    {
      success: true,
      message:,
      disposable_income: ie_statement.disposable_income,
      ie_statement:,
      income_entries: ie_statement.statement_entries.was_income,
      expenditure_entries: ie_statement.statement_entries.was_expenditure,
      debt_payment_entries: ie_statement.statement_entries.was_debt_payment,
      ie_rating: ie_statement.ie_rating
    }
  end

  def ie_statement_params
    params[:ie_statement].permit(:name)
  end

  def save_statement_entries(ie_statement, entry_type)
    # %i[income expenditure debt_payment].each do |entry_type|
      params[entry_type][:description].each_with_index do |description, index|
        StatementEntry.create!(
          description:, amount: params[entry_type][:amount][index], entry_type:, ie_statement:
        )
      end
    # end
  end
end
