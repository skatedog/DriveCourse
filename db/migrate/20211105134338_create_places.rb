class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.decimal :latitude, precision: 9, scale: 7, null: false
      t.decimal :longitude, precision: 10, scale: 7, null: false
      t.string :address, null: false
      t.timestamps
    end
  end
end
