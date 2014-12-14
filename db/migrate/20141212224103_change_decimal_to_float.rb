class ChangeDecimalToFloat < ActiveRecord::Migration
  def change
  		change_column :stops, :latitude, :float
  		change_column :stops, :longitude, :float
  end
end
