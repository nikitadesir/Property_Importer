class CreateUnits < ActiveRecord::Migration[8.1]
  def change
    create_table :units do |t|
      t.references :property, null: false, foreign_key: true
      t.string :unit_number, null: false
      t.timestamps
    end
    add_index :units, [:property_id, :unit_number], unique: true, name: 'index_units_on_property_and_normalized_unit_number'
  end
end
