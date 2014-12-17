class AddCodedTimesToStop < ActiveRecord::Migration
  def change
  	add_column :stops, :coded_times, :timestamp, array: true, default: '{}'
  end
end
