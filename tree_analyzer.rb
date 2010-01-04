require 'rubygems'
require 'stanfordparser'
require 'json'
require 'open-uri'

class TreeAnalyzer

	##
	def initialize(tree)
		@tree = tree
	end
	
	##
	def find_location

		it = @tree.iterator
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

	## 
	def get_people

		it = @tree.iterator
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
				names = toks.split(/\)\s*/).map{ |x| x.gsub(/^\([A-Z]*\s*/, '') }
			
				# now we have a structure like this to extract names:
				# n    : [[0,3], [4,2]]
				# names: ["George", "W.", "Bush", "and", "Al", "Gore"]
				people << n.inject([]){ |acum,obj| acum << names.slice(obj.first, obj.last).join(" ") }
			end
		end
		people.flatten
	end

	##
	def coords_from_location(location)

		url = URI.escape("http://maps.google.com/maps/geo?q=#{location}&output=json")
	
		open(url) do |f|
			@obj = JSON.parse(f.read) 
		end
	
		return nil if @obj["Status"]["code"] != 200
	
		@obj["Placemark"][0]["Point"]["coordinates"]
	end

	##
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

	##
	# returns false or array with all sequences of singular, adjacent,
	# proper nouns (NNPS) longer than 2 elements
	#
	# format: [[start_pos, length], [...]] || false
	def refers_to_person(it)

		nodes = it.localTree.inject([]){ |acum, obj| acum << obj.label.to_s }
	
		# count number of adjacent "NNP" in nodes, starting with the first found
		original_size = nodes.size
		nnps = [[0,0]]
		while not nodes.empty?
			n = nodes.shift
			
			if n == "NNP"
			
				l = nnps.pop
				if l.last == 0
					nnps << [original_size - nodes.size - 2, 1]
				else
					nnps << [l.first, l.last + 1]
				end
				
			elsif n != "NNP" and nnps.last.last > 0
				nnps << [0,0]
			end
		end
	
		# remove all subsequences less than 2 NNPs long
		nnps.reject!{ |x| x.last < 2 }
	
		return nnps.empty? ? false : nnps
	end

end
