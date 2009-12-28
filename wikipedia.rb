require 'rubygems'
require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/1974"))

puts doc.xpath("//span[starts-with(@id,'Births')]//../../preceding::span[@class='mw-headline']/parent::h3/following-sibling::ul[1]").size
