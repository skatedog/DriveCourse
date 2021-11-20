class CreateSpots < ActiveRecord::Migration[5.2]
  def change
    create_table :spots do |t|
      t.integer :course_id, null: false
      t.integer :genre_id
      t.integer :sort_number, null: false
      t.string :name, null: false
      t.text :introduction
      t.decimal :latitude, precision: 9, scale: 7, null: false
      t.decimal :longitude, precision: 10, scale: 7, null: false
      t.string :address, null: false
      t.boolean :stopover, null: false, default: true
      t.json :spot_images
      t.timestamps
    end
  end
end
