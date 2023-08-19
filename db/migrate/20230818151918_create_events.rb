class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name, unique: true
      t.string :description
      t.json :rules
      t.timestamps
    end
  end
end
