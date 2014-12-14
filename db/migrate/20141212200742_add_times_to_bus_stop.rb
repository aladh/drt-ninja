class AddTimesToBusStop < ActiveRecord::Migration
  def change
  	add_column :bus_stops, :latitude, :decimal
  	add_column :bus_stops, :longitude, :decimal
  end
end
