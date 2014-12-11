class BussesController < ApplicationController

	def index
		f = File.open("app/assets/javascripts/route_names.json", "r")
		@route_names = JSON.parse(f.read)
		f.close
	end

	def show
		@schedule = Bus.where(route: params[:id]).find_by(day: params[:day])
		render :json => @schedule 
	end

end
