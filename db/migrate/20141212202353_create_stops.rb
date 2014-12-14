class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
    	t.string :name
  		t.string :location
  		t.decimal :latitude
  		t.decimal :longitude
  		t.string :times, array: true, default: []
      t.timestamps
    end
  end
end
