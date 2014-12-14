class AddBusIdToStops < ActiveRecord::Migration
  def change
  	add_column :stops, :bus_id, :integer
  end
end
