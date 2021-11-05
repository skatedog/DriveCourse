class CreateVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicles do |t|
      t.integer :user_id, null: false
      t.integer :use_for, null: false, default: 0
      t.integer :category, null: false, default: 0
      t.string :maker, null: false
      t.integer :displacement, null: false
      t.string :name, null: false
      t.text :introduction
      t.json :vehicle_images
      t.timestamps
    end
  end
end
