class AddFieldsToBusStop < ActiveRecord::Migration
  def change
  	add_column :bus_stops, :name, :string
  	add_column :bus_stops, :location, :string
  	add_column :bus_stops, :times, :string, array: true, default: '{}'
  end
end
