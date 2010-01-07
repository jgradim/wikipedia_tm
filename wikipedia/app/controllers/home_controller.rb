class HomeController < ApplicationController
	def index
		@events = Event.newest_year_events
		@newest_year = Event.newest_year
		@oldest_year = Event.oldest_year
		
		respond_to do |format|
			format.html
		end
	end
end
