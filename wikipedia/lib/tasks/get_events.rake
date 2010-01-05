require 'stanfordparser'
require 'tree_analyzer'
require 'wikipedia_extractor'
require 'wp_classifier'

task :get_events do

	arevents = []
	
	parser = StanfordParser::LexicalizedParser.new
	wikipedia_extractor = WikipediaExtractor.new
	wp_classifier = WPClassifier.new
	
	(1900..1900).each do |year|
	
		t = Time.now
		print "Processing events from #{year}... "
	
		events = wikipedia_extractor.get_events(year)
		
		events.each do |event|
		
			# get location, people and coordinates
			tree = parser.apply(event[:description])
			tree_analyzer = TreeAnalyzer.new(tree)
			
			people = tree_analyzer.get_people.join(',')
			location = tree_analyzer.find_location
			lat, lng = nil, nil
			if location
				lat, lng = tree_analyzer.coords_from_location(location)
			end
			
			# classify event
			type = wp_classifier.classify(event[:description])
			
			# update event with new info
			event.merge!({
				:type => type,
				:location => location,
				:lat => lat,
				:lng => lng,
				:people => people
			})
			
			arevents << event
			
		end
		puts "[took #{(Time.now - t).to_i} seconds]"
	end
	
	# output to file
	File.open('lib/tasks/events.rb', 'w+') do |f|
		f.write("@events = ")
		f.write(arevents.inspect)
	end
	puts "Created file events.rb in lib/tasks directory. Please run rake populate_db to create events."
	
end
