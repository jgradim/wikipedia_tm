require 'date'
require 'rubygems'
require 'nokogiri'
require 'open-uri'

for year in 1000..2000
	doc = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/#{year}"))

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
	data.each do |event|
		temp = Date.parse("#{year.to_s} " + event.text) rescue Date.ordinal(year)
		date = Date.new(year, temp.month.to_i, temp.day.to_i)

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
