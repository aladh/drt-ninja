class BussesController < ApplicationController

	def index
		f = File.open("app/assets/javascripts/route_names.json", "r")
		@route_names = JSON.parse(f.read)
		f.close
		@test_coords = []
		@test_coords[0] = 43.840035
		@test_coords[1] = -79.123702 
		stops = Bus.where(route: "110").find_by(day: "weekday").stops
  	@locations = []
  	stops.each do |stop|
  		@locations.push({latitude: stop["lat"], longitude: stop["lon"]})
		end
	end

	def show
		@schedule = Bus.where(route: params[:id]).find_by(day: params[:day])
		render :json => @schedule 
	end

end
