class CreateSightings < ActiveRecord::Migration[7.0]
  def change
    create_table :sightings do |t|
      t.integer :animal_id
      t.datetime :date
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
