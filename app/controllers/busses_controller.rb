class BussesController < ApplicationController

	def index
	end

	def show
		f = File.open("app/assets/javascripts/#{params[:id]}.json", "r")
		@route = f.read
		f.close
		render :json => @route 
	end

end
