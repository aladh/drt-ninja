class BussesController < ApplicationController

	def index
		if request.xhr? && params[:lat] && params[:lon]
			@stops = Stop.near([params[:lat], params[:lon]], 0.2, units: :km).to_a
			p @stops.count
			@stops.delete_if do |stop|
				stop.bus.day == 'saturday' || stop.bus.day == 'sunday'
			end
			p @stops.count
			render :json => @stops
		else
			f = File.open("app/assets/javascripts/route_names.json", "r")
			@route_names = JSON.parse(f.read)
			f.close
		end
	end

	def show
		@schedule = Bus.where(route: params[:id]).find_by(day: params[:day]).stops
		render :json => @schedule 
	end

end
