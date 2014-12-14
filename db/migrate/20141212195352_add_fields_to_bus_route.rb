class AddFieldsToBusRoute < ActiveRecord::Migration
  def change
  	add_column :bus_routes, :name, :string
  	add_column :bus_routes, :route, :string
  	add_column :bus_routes, :day, :string
  end
end
