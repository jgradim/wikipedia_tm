class EventsController < ApplicationController

	def search
		
		@events = Event.find(:all, :conditions => ['YEAR(date) = ?', params[:year])
		
		respond_to do |format|
			format.json { render :json => @events }
		end
	end
end
