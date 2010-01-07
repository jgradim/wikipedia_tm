class EventsController < ApplicationController

	## GET
	def search
		categories = params[:categories].map{ |k,v| k } || []
		
		@events = Event.find(:all, :conditions => [ "category IN (?) AND description LIKE ?", categories, params[:keywords] + '%'])

		
		respond_to do |format|
		 format.html { render :template => 'home/index' }
		end
	end
end
