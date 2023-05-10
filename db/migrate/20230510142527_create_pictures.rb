class CreatePictures < ActiveRecord::Migration[7.0]
  def change
    create_table :pictures do |t|
      t.string :path
      t.references :imageable, polymorphic: true, null: false
      t.references :employees, foreign_key: true
      t.references :products, foreign_key: true

      t.timestamps
    end
  end
end
