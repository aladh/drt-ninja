class CreateBuses < ActiveRecord::Migration
  def change
    create_table :buses do |t|
  		t.string :name
  		t.string :route
  		t.string :day
      t.timestamps
    end
  end
end
