class Stop < ActiveRecord::Base
	belongs_to :bus
	geocoded_by :location
end
