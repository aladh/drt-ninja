class Bus
	include Mongoid::Document
	include Mongoid::Attributes::Dynamic

	# Schema
	# name: "110A Central Pickering"
	# route: "110A"
	# day: "weekday" or saturday or sunday
	# stops: [{name: , lat: , lon: , times: [] }, {}, {}]
end
