require 'date'
require 'rubygems'
require 'nokogiri'
require 'open-uri'

class WikipediaExtractor

	def initialize
		@base_url = 'http://en.wikipedia.org/wiki/'
	end
	
	##
	# Get wikipedia events for a certain year
	def get_events(year)
	
		url = URI.escape("#{@base_url}#{year}")	
		doc = Nokogiri::HTML(open(url))
		
		data = doc.xpath("//span[starts-with(@id,'Births')]//../../preceding::span[@class='mw-headline']/parent::h3/following-sibling::ul[1]/li")

		if data.to_s == ''
			data = doc.xpath("//span[starts-with(@id,'Deaths')]//../../preceding::span[@class='mw-headline']/parent::h3/following-sibling::ul[1]/li")
		end
	
		if data.to_s == ''
			data = doc.xpath("//span[starts-with(@id,'Births')]//../../preceding::span[@class='mw-headline']/parent::h2/following-sibling::ul[1]/li")
			if data.to_s == ''
				data = doc.xpath("//span[starts-with(@id,'Deaths')]//../../preceding::span[@class='mw-headline']/parent::h2/following-sibling::ul[1]/li")
			end
		end
		
		# process all events found
		events = []
		data.each do |event|
			temp = Date.parse("#{year.to_s} " + event.text) rescue Date.ordinal(year)
			date = Date.new(year, temp.month.to_i, temp.day.to_i)

			if event.at_css('ul') == nil
				sentence = event.text.gsub(/^.* – /, '')
				events << { :date => date.to_s, :description => sentence }
			else
				event.css("li").each do |sub_event|
					sentence = sub_event.text
					events << { :date => date.to_s, :description => sentence }
				end
			end
		end
		events
	end

end
