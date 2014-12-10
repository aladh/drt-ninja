namespace :stops do
	desc "Find coordinates for bus stops"
  task :locate => :environment do
    f = File.open("app/assets/javascripts/schedules/110.json", "r")
		names = JSON.parse(f.read)
		f.close

		# Remove everything but name, add city and province
		long_names = names.keys.map { |name| 
			name[17..-1].gsub(/[a-z]/,"").strip + ", Pickering, Ontario"
		}
		#p names
		
		# locations = {}

		# # Get coordinates for each name
		# i = 0
		# while i < 3 do
		# 	locations[names[i]] = Geocoder.search(long_names[i])[0].geometry["location"]
		# 	p locations[names[i]]
		# 	i = i + 1
		# end
	
		# p locations

		locations = []

		# Get coordinates for each name
		i = 0
		while i < long_names.length do
			geo = Geocoder.search(long_names[i])[0].geometry["location"]
			geo["latitude"] = geo["lat"]
			geo["longitude"] = geo["lng"]
			geo.delete("lat")
			geo.delete("lng")
			locations.push(geo)
			i = i + 1
			if i % 5 == 0
				sleep(2)
			end
		end
	
		p locations
	end
end
