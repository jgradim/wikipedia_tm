require 'rubygems'
require 'stanfordparser'
require 'rjb'

def find_location(tree)

	it = tree.iterator
	location = ""
	
	while it.hasNext
		node = it.next
		puts node.to_s unless node.to_s.match(/\(.*\)/)
		if node.label.to_s === 'PP'
			location = node.toString #not optimal, but contains location
			break
		end
	end
	
	puts location
	m = location.match(/([\w,]+)(?=\))/) # works in rubular, no idea why it doesn't work here
	puts m.size
end

parser = StanfordParser::LexicalizedParser.new

tree = parser.apply("The 1988 Summer Olympics are held in Seoul, South Korea.")

find_location(tree)
