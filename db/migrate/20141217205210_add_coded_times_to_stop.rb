class AddCodedTimesToStop < ActiveRecord::Migration
  def change
  	add_column :stops, :coded_times, :time, array: true, default: '{}'
  end
end
