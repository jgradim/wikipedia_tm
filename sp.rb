require 'rubygems'
require 'stanfordparser'
require 'json'
require 'open-uri'


def find_location(tree)

	it = tree.iterator
	location = ""
	
	while it.hasNext
		node = it.next
		if node.label.to_s == 'PP' and is_location(node.iterator)
			location = node.toString #not optimal, but contains location
			break
		end
	end
	puts location.scan(/([\w,]+)(?=\))/).join(" ")
	location.scan(/([\w,]+)(?=\))/).join(" ").gsub(/^in |^from |^of |^to |^at |^the /i, '').gsub(' ,', ',')
end

# determines if a subtree is a location
def is_location(it)
	nodes = []
	while nodes.size < 5 and it.hasNext
		label = it.next.label.to_s
		if label.match(/[A-Z]{2,3}/)
			nodes << label
			break	if nodes.size == 4 and label == "NNP" # Stop matching, successful
		end
	end
	
	puts "nodes: "+nodes.inspect
	
	[["PP", "IN", "NP", "NNP"],
	 ["PP", "TO", "NP", "NNP"],
	 ["PP", "IN", "NP", "NP", "NNP"],
	 ["PP", "TO", "NP", "NP", "NNP"],
	 ["PP", "IN", "NP", "DT", "NNP"]].include? nodes
end

def coords_from_location(location)

	url = URI.escape("http://maps.google.com/maps/geo?q=#{location}&output=json")
	
	open(url) do |f|
		@obj = JSON.parse(f.read) 
	end
	
	return nil if @obj["Status"]["code"] != 200
	
	@obj["Placemark"][0]["Point"]["coordinates"]

end

parser = StanfordParser::LexicalizedParser.new
sentence = ARGV[0] || "The 1988 Summer Olympics are held in Seoul, South Korea."
tree = parser.apply(sentence)

loc = find_location(tree)

puts "Location    : "+loc
puts "Coordinates : "+coords_from_location(loc).join(", ") if loc
