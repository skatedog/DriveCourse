class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.integer :user_id, null: false
      t.integer :vehicle_id
      t.string :name, null: false
      t.text :introduction, null: false
      t.boolean :is_protected, null: false, default: true
      t.timestamps
    end
  end
end
