class EventsController < ApplicationController

	## GET
	def search
		categories = params[:categories] || []
		
		@events = Event.find(:all, :conditions => ['category in (?) AND YEAR(date) = ?', categories, params[:year]])
		@newest_year = Event.newest_year
		@oldest_year = Event.oldest_year
		
		respond_to do |format|
		 format.html { render 'home/index' }
		 format.js { render :partial => 'events_list' }
		end
	end
end
