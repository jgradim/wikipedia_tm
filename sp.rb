require 'rubygems'
require 'stanfordparser'
require 'rjb'

def find_location(tree)

	it = tree.iterator
	location = ""
	
	while it.hasNext
		node = it.next
		if node.label.to_s === 'PP'
			location = node.toString #not optimal, but contains location
			break
		end
	end
	
	location.scan(/([\w,]+)(?=\))/).join(" ").gsub(/^in |^from |^of /i, '').gsub(' ,', ',')
end

parser = StanfordParser::LexicalizedParser.new

sentence = ARGV[0] || "The 1988 Summer Olympics are held in Seoul, South Korea."

tree = parser.apply(sentence)

puts find_location(tree)
