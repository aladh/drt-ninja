class BussesController < ApplicationController
	require 'time'

	def index
		if request.xhr? && params[:lat] && params[:lon]
			@stops = Stop.near([params[:lat], params[:lon]], 0.2, units: :km).to_a
			@stops.delete_if do |stop|
				stop.bus.day == 'saturday' || stop.bus.day == 'sunday'
			end
			p @stops.count
			@stops = @stops.group_by {|stop| stop.bus.route}
			@stops.keys.each {|key| @stops[key] = @stops[key][0]}
			@nearby = []
			# Convert current time to 2014-01-01
			current_time = Time.parse(Time.now.to_s[11..-7], Time.parse("2014-01-01")).getutc
			p current_time
			p @stops
			@stops.keys.each do |key| 
				next_time = Time.parse(Time.now.to_s[11..-7], Time.parse("2014-01-01")).getutc.to_f * 1000
				@stops[key].coded_times.each do |time|
					p time
					if current_time < time
						next_time = time
						p true
						break
					end
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
