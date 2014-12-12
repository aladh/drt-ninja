class AddOrdinalToStops < ActiveRecord::Migration
  def change
  	add_column :stops, :ordinal, :integer
  end
end
