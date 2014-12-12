namespace :busses do
	desc "Geocode and save bus routes"
  task :save => :environment do
    
    # Remove everything but stop name, add city and province
  	def long_stop_names(filename, schedule)
  		
  		# Set city based on route name
  		city = ""
  		case filename[0].to_i
  		when 1 then
  			city = "Pickering"
  		when 2 then
  			city = "Ajax"
  		when 3 then
  			city = "Whitby"
  		when 4 then
  			city = "Oshawa"
  		when 5 then
  			city = "Clarington"
			end

			# Add province and country
			city  = city + ", Ontario, Canada"
  		
  		long_names =  schedule.keys.map { |name| 
				name[17..-1].gsub(/[a-z]/,"").strip + ", " + city
			}
			return long_names
  	end

  	# Get route names
  	def get_route_names
  		f = File.open("app/assets/javascripts/route_names.json", "r")
			route_names = JSON.parse(f.read)
			f.close
			return route_names
		end

		# Get schedule
		def get_schedule(filename)
			f = File.open("app/assets/javascripts/schedules/#{filename}", "r")
			schedule = JSON.parse(f.read)
			f.close
			return schedule
		end

		# Get full route name
		def get_full_name(filename, route_names)
			filename = filename.gsub(".json","").gsub("-sat","").gsub("-sun","").gsub("_","/")
			return route_names[filename]
		end

		# Get short route name
		def get_short_name(filename)
			return filename.gsub(".json","").gsub("-sat","").gsub("-sun","")
		end

		# Get day of schedule based on filename
		def get_day(filename)
			if filename.include?("sat")
				'saturday'
			elsif filename.include?("sun")
				'sunday'
			else
				'weekday'
			end
		end

		# Make bus object
		def make_bus(filename, route_names)
			bus = {}
			bus[:name] = get_full_name(filename, route_names)
			bus[:route] = get_short_name(filename)
			bus[:day] = get_day(filename)
			bus[:stops] = []
			return bus
		end

		# Get coordinates for each stop and push to bus object
		def geocode_stops(schedule, bus, long_names)
			i = 0
			while i < schedule.keys.length do
				print "Getting coordinates for " + long_names[i] + " ..."
				geo = Geocoder.search(long_names[i])[0].geometry["location"]
				bus[:stops].push({name: schedule.keys[i], lat: geo["lat"], lon: geo["lng"], times: schedule.values[i]})
				puts "Done!"
			  puts "______________________________________________________________________________"
				i = i + 1
				
				# If geocoding API limit/second is hit then sleep
				if i % 5 == 0
					print "Sleeping."
					10.times do
						print "."
						sleep(0.2)
					end
					puts
					puts
				end
			end
		end

		# Set filename
		# filename = "110.json"

		# Get route names
	  route_names = get_route_names

		Dir.foreach('app/assets/javascripts/schedules/') do |filename|
			next if filename == '.' or filename == '..' or filename == ".DS_Store"

	  	# Open file
	    schedule = get_schedule(filename)
	    
	    # Remove everything but stop name, add city and province
			long_names = long_stop_names(filename, schedule)

			# Make bus object
			bus = make_bus(filename, route_names)

			# Get coordinates for each stop and push to bus object
			geocode_stops(schedule, bus, long_names)

			# Save bus object
			Bus.create(bus)
			puts
			puts
			puts
			puts "Saved #{bus[:name]}!" 	
			puts
			puts
			puts
		end
	end

	desc "Find coordinates for bus stops"
  task :locate => :environment do
  	stops = Bus.where(route: "110").find_by(day: "weekday").stops
  	locations = []
  	stops.each do |stop|
  		locations.push({latitude: stop["lat"], longitude: stop["lon"]})
		end

  	p locations
	end
end
