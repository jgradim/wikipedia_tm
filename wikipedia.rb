require 'date'
require 'rubygems'
require 'nokogiri'
require 'open-uri'

for year in 1912..1912
	doc = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/#{year}"))

	data = doc.xpath("//span[starts-with(@id,'Births')]//../../preceding::span[@class='mw-headline']/parent::h3/following-sibling::ul[1]/li")

	if data.to_s == ''
		data = doc.xpath("//span[starts-with(@id,'Deaths')]//../../preceding::span[@class='mw-headline']/parent::h3/following-sibling::ul[1]/li")
	end
	
	data.each do |event|
		date = Date.parse("#{year.to_s} " + event.at_css('.mw-formatted-date').text) rescue "rescue"

		if event.at_css('ul') == nil
			sentence = event.text.gsub(/^.* – /, '')
			puts date.to_s + " - " + sentence.to_s
		else
			event.css("li").each do |sub_event|
				sentence = sub_event.text
				puts date.to_s + " - " + sentence.to_s
			end
		end
		
		
		
	end
end
