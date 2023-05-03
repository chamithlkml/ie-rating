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
        message: 'Your Income/Expenditure statement is added!'
      }

    rescue Exception => e
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

end
