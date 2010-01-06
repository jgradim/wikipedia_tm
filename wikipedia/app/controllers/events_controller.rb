class EventsController < ApplicationController

	def search
		
		@events = Event.year_events(params[:year])
		
		respond_to do |format|
			format.json { render :json => @events }
		end
	end
end
