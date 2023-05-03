class IeStatementsController < ApplicationController
  def new
    @ie_statement = IeStatement.new

    render
  end

  def create
    begin

      ActiveRecord::Base.transaction do
        @ie_statement = IeStatement.new(ie_statement_params)
        @ie_statement.user = current_user

        if @ie_statement.save!
          params[:income][:description].each_with_index do |description, index|
            @income = StatementEntry.new(
              description: description,
              amount: params[:income][:amount][index],
              entry_type: :income,
              ie_statement: @ie_statement
            )
            @income.save!
          end

          params[:expenditure][:description].each_with_index do |description, index|
            @expenditure = StatementEntry.new(
              description: description,
              amount: params[:expenditure][:amount][index],
              entry_type: :expenditure,
              ie_statement: @ie_statement
            )
            @expenditure.save!
          end

          params[:debt_payment][:description].each_with_index do |description, index|
            @debt_payment = StatementEntry.new(
              description: description,
              amount: params[:debt_payment][:amount][index],
              entry_type: :debt_payment,
              ie_statement: @ie_statement
            )
            @debt_payment.save!
          end

        end
      end

      render json: {
        success: true,
        message: 'Your Income/Expenditure statement is added!',
        disposable_income: disposable_income,
        ie_statement: @ie_statement,
        income_entries: @ie_statement.statement_entries.where(entry_type: :income),
        expenditure_entries: @ie_statement.statement_entries.where(entry_type: :expenditure),
        debt_payment_entries: @ie_statement.statement_entries.where(entry_type: :debt_payment),
        ie_rating: calculate_ie_rating
      }

    rescue StandardError => e
      render json: {
        sucess: false,
        message: e.message
      }
    end
  end

  def index
    begin
      render json: {
        success: true,
        ie_statements: current_user.ie_statements
      }
    rescue StandardError => e
      render json: {
        sucess: false,
        message: e.message
      }
    end
  end

  def show
    begin
      found_ie_statement_id = current_user.ie_statements.where(id: params[:id]).first.try(:id)

      raise 'Statement not found' if found_ie_statement_id.nil?

      @ie_statement = IeStatement.find(found_ie_statement_id)

      render json: {
        success: true,
        disposable_income: disposable_income,
        ie_statement: @ie_statement,
        income_entries: @ie_statement.statement_entries.where(entry_type: :income),
        expenditure_entries: @ie_statement.statement_entries.where(entry_type: :expenditure),
        debt_payment_entries: @ie_statement.statement_entries.where(entry_type: :debt_payment),
        ie_rating: calculate_ie_rating
      }
    rescue StandardError => e
      render json: {
        sucess: false,
        message: e.message
      }
    end
  end

  private

  def ie_statement_params
    params[:ie_statement].permit(:name)
  end

  def total_expenditure
    expenditure = @ie_statement.statement_entries.where(entry_type: :expenditure).sum(:amount)
    debt_payments = @ie_statement.statement_entries.where(entry_type: :debt_payment).sum(:amount)
    expenditure + debt_payments
  end

  def total_income
    @ie_statement.statement_entries.where(entry_type: :income).sum(:amount)
  end

  def disposable_income
    total_income - total_expenditure
  end

  def calculate_ie_rating
    income = total_income
    return 'Income cannot be 0' if income.zero?

    ie_ratio = (total_expenditure / total_income.to_f) * 100

    ie_rating = ''

    if ie_ratio < 10
      ie_rating = 'A'
    elsif ie_ratio >= 10 && ie_ratio < 30
      ie_rating = 'B'
    elsif ie_ratio >= 30 && ie_ratio < 50
      ie_rating = 'C'
    else
      ie_rating = 'D'
    end

    ie_rating
  end
end
