class CreateIeStatements < ActiveRecord::Migration[7.0]
  def change
    create_table :ie_statements do |t|
      t.string :name, null: false, default: ""
      t.references :user, index: true, foreign_key: true
      t.datetime :discarded_at, :datetime
      t.timestamps
    end
  end
end
