require 'rubygems'
require 'stanfordparser'
require 'json'
require 'open-uri'
require 'tree_analyzer'

parser = StanfordParser::LexicalizedParser.new
sentence = ARGV[0] || "The 1988 Summer Olympics are held in Seoul, South Korea."
tree = parser.apply(sentence)

ta = TreeAnalyzer.new(tree)

puts ta.get_people
puts ta.find_location

puts "Location    : "+loc
puts "Coordinates : "+coords_from_location(loc).join(", ") if loc
