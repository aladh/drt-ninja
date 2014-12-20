class BussesController < ApplicationController
	require 'time'

	def index
		if request.xhr? && params[:lat] && params[:lon]
			@stops = Stop.near([params[:lat], params[:lon]], 0.25, units: :km).to_a
			@stops.delete_if do |stop|
				stop.bus.day == 'saturday' || stop.bus.day == 'sunday'
			end
			@stops = @stops.group_by {|stop| stop.bus.route}
			@stops.keys.each {|key| @stops[key] = @stops[key][0]}
			@nearby = []
			# Convert current time to 2014-01-01
			current_time = Time.parse(Time.now.to_s[11..-7], Time.parse("2014-01-01")).getutc
			@stops.keys.each do |key| 
				next_time = nil
				@stops[key].coded_times.each do |time|
					if current_time < time
						next_time = Time.parse(time.getlocal.to_s[11..-7])
						break
					end
				end
				if next_time != nil
					@nearby.push({route: key, stop: @stops[key], time: next_time}) 
				end
			end
			@nearby = @nearby.sort {|a,b| a[:time].to_i <=> b[:time].to_i}
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
