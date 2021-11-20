class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.integer :user_id, null: false
      t.integer :vehicle_id
      t.string :name, null: false
      t.text :introduction
      t.boolean :is_recorded, null: false, default: false
      t.boolean :avoid_highways, null: false, default: false
      t.boolean :avoid_tolls, null: false, default: false
      t.datetime :departure, null: false
      t.timestamps
    end
  end
end
