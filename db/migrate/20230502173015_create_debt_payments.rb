class CreateDebtPayments < ActiveRecord::Migration[7.0]
  def change
    create_table :debt_payments do |t|
      t.string :description, null: false, default: ""
      t.integer :amount, default: 0
      t.references :ie_statement, index: true, foreign_key: true
      t.datetime :discarded_at, :datetime
      t.timestamps
    end
  end
end
