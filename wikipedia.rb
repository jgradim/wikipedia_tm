require 'date'
require 'rubygems'
require 'nokogiri'
require 'open-uri'


for i in 1912..1912
	doc = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/#{i}"))

	doc.xpath("//span[starts-with(@id,'Births')]//../../preceding::span[@class='mw-headline']/parent::h3/following-sibling::ul[1]/li").each do |event|

		date = Date.parse('1912 ' + f.at_css('.mw-formatted-date').text) rescue "rescued"

		if event.at_css('ul') == nil
			puts event.text.gsub(/^.* – /, '')
		else
			event.css("li").each do |sub_event|
				puts sub_event.text
			end
		end
	end
end
