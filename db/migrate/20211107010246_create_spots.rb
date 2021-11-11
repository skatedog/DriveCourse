class CreateSpots < ActiveRecord::Migration[5.2]
  def change
    create_table :spots do |t|
      t.integer :course_id, null: false
      t.integer :place_id, null: false
      t.integer :sort_number, null: false
      t.boolean :stopover, null: false, default: true
      t.boolean :is_protected, null: false, default: true
      t.json :place_images
      t.timestamps
    end
  end
end
