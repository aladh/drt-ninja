class BussesController < ApplicationController

	def index
		f = File.open("app/assets/javascripts/schedules/route_names.json", "r")
		@bus_routes = JSON.parse(f.read)
		f.close
		@test_coords = [43.8401310, -79.1237670]

		# Get locations
		f2 = File.open("app/assets/javascripts/schedules/110.json", "r")
		names = JSON.parse(f2.read)
		f2.close

		# Remove everything but name, add city and province
		long_names = names.keys.map { |name| 
			name[17..-1].gsub(/[a-z]/,"").strip + ", Pickering, Ontario"
		}

		locations = []

		# Get coordinates for each name
		i = 0
		while i < 4 do
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

    @bus_stops = locations
	end

	def show
		f = File.open("app/assets/javascripts/schedules/#{params[:id]}.json", "r")
		@schedule = f.read
		f.close
		render :json => @schedule 
	end

end
