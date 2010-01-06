class HomeController < ApplicationController
	def index
		@events = Event.newest_year_events
		
		respond_to do |format|
			format.html
		end
	end
end
