class AddCodedTimesToStop < ActiveRecord::Migration
  def change
  	add_column :stops, :coded_times, :datetime, array: true, default: []
  end
end
