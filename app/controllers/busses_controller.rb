class BussesController < ApplicationController

	def index
		f = File.open("app/assets/javascripts/route_names.json", "r")
		@bus_routes = JSON.parse(f.read)
		f.close
	end

	def show
		f = File.open("app/assets/javascripts/#{params[:id]}.json", "r")
		@schedule = f.read
		f.close
		render :json => @schedule 
	end

end
