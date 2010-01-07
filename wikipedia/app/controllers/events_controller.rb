class EventsController < ApplicationController

	## GET
	def search
		categories = params[:categories].map{ |k,v| k } || []
		
		@events = Event.find(:all, :conditions => { :category => categories })
		
		respond_to do |format|
		 format.html { render 'home/index' }
		end
	end
end
