class CreateProperties < ActiveRecord::Migration[8.1]
  def change
    create_table :properties do |t|
      t.string :building_name, null: false
      t.string :street_address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false
      t.timestamps
    end
    add_index :properties, 'LOWER(building_name), LOWER(street_address), LOWER(city), LOWER(state), LOWER(zip_code)', unique: true, name: 'index_properties_on_normalized_address'
  end
end
