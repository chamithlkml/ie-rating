class CreateStatementEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :statement_entries do |t|
      t.string :description, null: false, default: ''
      t.integer :amount, default: 0
      t.references :ie_statement, index: true, foreign_key: true
      t.integer :entry_type, null: false, default: 0
      t.datetime :discarded_at, :datetime
      t.timestamps
    end
    add_index :statement_entries, :entry_type
  end
end
