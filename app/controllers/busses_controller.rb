class BussesController < ApplicationController
	require 'time'

	def index
		if request.xhr? && params[:lat] && params[:lon]
			@stops = Stop.near([params[:lat], params[:lon]], 0.2, units: :km).to_a
			p @stops.count
			@stops.delete_if do |stop|
				stop.bus.day == 'saturday' || stop.bus.day == 'sunday'
			end
			@stops = @stops.group_by {|stop| stop.bus.route}
			@stops.keys.each {|key| @stops[key] = @stops[key][0]}
			@nearby = []
			@stops.keys.each do |key| 
				# Convert current time to 2014-01-01
				current_time = Time.parse(Time.now.to_s[11..-7], Time.parse("2014-01-01")).getutc
				next_time = nil
				@stops[key].coded_times.each do |time|
						next_time = time if current_time < time
						break
				end
				@nearby.push({route: key, stop: @stops[key], time: next_time})
			end
			render :json => @nearby
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
