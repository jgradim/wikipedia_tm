require 'stanfordparser'
require 'tree_analyzer'
require 'wikipedia_extractor'
require 'wp_classifier'

task :get_events do

	arevents = []
	
	parser = StanfordParser::LexicalizedParser.new
	wikipedia_extractor = WikipediaExtractor.new
	wp_classifier = WPClassifier.new
	
	(1985..1995).each do |year|
	
		t = Time.now
		puts "Processing events from #{year}... "
	
		events = wikipedia_extractor.get_events(year)
		
		events.each do |event|
		
			# get location, people and coordinates
			tree = parser.apply(event[:description])
			tree_analyzer = TreeAnalyzer.new(tree)
			
			people = tree_analyzer.get_people.join(',') rescue nil
			location = tree_analyzer.find_location
			lat, lng = nil, nil
			if location
				lat, lng = tree_analyzer.coords_from_location(location)
			end
			
			# classify event
			category = wp_classifier.classify(event[:description])
			
			# update event with new info
			event.merge!({
				:category => category,
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
	puts "Created file events.rb in lib/tasks."
	puts "It contains an array (@events) of all extracted events."
	puts "Use it to populate the database using the Rails console."
	
end
