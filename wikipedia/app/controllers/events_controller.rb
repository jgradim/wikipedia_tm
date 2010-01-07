class EventsController < ApplicationController

	## GET
	def search
		categories = params[:categories] || []
		@events = Event.find(:all, :conditions => [ "category IN (?) AND description LIKE ? AND YEAR(date) = ?", categories, "%#{params[:keywords]}%", params[:year]])
		@newest_year = Event.newest_year
		@oldest_year = Event.oldest_year
		@year = params[:year]
		
		@accidents = categories.include? 'Accidents' || false
		@cultural = categories.include? 'Cultural' || false
		@crime = categories.include? 'Crime' || false
		@economy = categories.include? 'Economy' || false
		@politics = categories.include? 'Politics' || false
		@science = categories.include? 'Science' || false
		@war = categories.include? 'War' || false
		
		respond_to do |format|
		 format.html { render 'home/index' }
		 format.js { render :partial => 'events_list' }
		end
	end
end
