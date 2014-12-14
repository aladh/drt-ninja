class DropExtraTables < ActiveRecord::Migration
  def change
  	drop_table :bus_routes
  	drop_table :bus_stops
  end
end
