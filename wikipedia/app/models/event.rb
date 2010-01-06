class Event < ActiveRecord::Base
	## return newest year
	def self.newest_year
		Event.find(:first, :order => 'date DESC').date.year
	end
	
	## return oldest year
	def self.oldest_year
		Event.find(:first, :order => 'date ASC').date.year
	end
	
	## return one year events
	def self.year_events(year)
		Event.find(:all, :conditions => ['YEAR(date) = ?', year])
	end

	## return 
	def self.newest_year_events
		self.year_events(self.newest_year)
	end
end
