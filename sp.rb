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
	location.scan(/([\w,]+)(?=\))/).join(" ").gsub(/^in |^from |^of |^to |^at |^the /i, '').gsub(' ,', ',')
end

def get_people(tree)

	it = tree.iterator
	people = []
	
	while it.hasNext
		node = it.next
		if node.label.to_s == 'NP' and (n = refers_to_person(node))
		
			# prepare string for children inspection
			# (remove root element and last closing parenthesis)
			toks = node.toString.gsub(/^\(.*\] (?=\()/, '').chop
			
			# remove inner brackets and content
			toks.gsub!(/ \[[\d\.]*\] /, ' ')
			
			# splits the tokens into an array; \s* ensures the last ) is also removed
			# even if it's not succeeded by whitespace
			names = toks.split(/\)\s*/)#.map{ |x| x.gsub(/^\([A-Z]*\s*/, '') }
			
			puts names.inspect
		end
	end
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
	
	[["PP", "IN", "NP", "NNP"],
	 ["PP", "TO", "NP", "NNP"],
	 ["PP", "IN", "NP", "NP", "NNP"],
	 ["PP", "IN", "NP", "DT", "NNPS"], # the netherlands :x
	 ["PP", "TO", "NP", "NP", "NNP"],
	 ["PP", "IN", "NP", "DT", "NNP"]].include? nodes
end

# returns false or array with number of all sequences of
# singular, adjacent, proper nouns (NNPS) longer than 2 elements
def refers_to_person(it)

	nodes = it.localTree.inject([]){ |acum, obj| acum << obj.label.to_s }
	
	# count number of adjacent "NNP" in nodes, starting with the first found
	original_size = nodes.size
	nnps = [0]
	while not nodes.empty?
		n = nodes.shift
		if n == "NNP"
			#nnps.last += 1 -> does not work
			
			nnps << nnps.pop + 1
		elsif n != "NNP" and nnps.last > 0
			nnps << 0
		end
	end
	
	# remove all subsequences less than 2 NNPs long
	nnps.reject!{ |x| x < 2 }
	
	return nnps.empty? ? false : nnps
	
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

get_people(tree)

loc = find_location(tree)

puts "Location    : "+loc
puts "Coordinates : "+coords_from_location(loc).join(", ") if loc
