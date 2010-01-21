require 'rubygems'
require 'stemmer'
require 'classifier'

class WPClassifierResults

	def initialize

		@path = "#{RAILS_ROOT}/assets/"
		
		# load files
		@accidents = YAML::load_file "#{@path}accidents.yml"
		@crime     = YAML::load_file "#{@path}crime.yml"
		@cultural  = YAML::load_file "#{@path}cultural.yml"
		@economy   = YAML::load_file "#{@path}economy.yml"
		@politics  = YAML::load_file "#{@path}politics.yml"
		@science   = YAML::load_file "#{@path}science.yml"
		@war       = YAML::load_file "#{@path}war.yml"
		
		# create classifier
		@bc = Classifier::Bayes.new('accidents', 'crime', 'cultural', 'economy', 'politics', 'science', 'war')
		
		# train classifier
		#@accidents.each { |x| @bc.train_accidents x }
		#@crime.each { |x| @bc.train_crime x }
		#@cultural.each { |x| @bc.train_cultural x }
		#@economy.each { |x| @bc.train_economy x }
		#@politics.each { |x| @bc.train_politics x }
		#@science.each { |x| @bc.train_science x }
		#@war.each { |x| @bc.train_war x }
	end
	
	def classify(sentence)
		@bc.classify sentence
	end
	
	def train_subsets
	
		slices = (0..49).to_a.sort_by{rand}
		categories = ['accidents', 'crime', 'cultural', 'economy', 'politics', 'science', 'war']
		file = File.open("#{RAILS_ROOT}/log/classification.log", "w")
		
		10.times do |i|
		
			file.write "\n\nCreating subsets ##{i+1}...\n"
			
			slice = slices[(5*i..5*i+4)]
			
			accidents_subset = slice.to_a.map{ |x| @accidents[x] }
			new_accidents = @accidents - accidents_subset
			crime_subset = slice.to_a.map{ |x| @crime[x] }
			new_crime = @crime - crime_subset
			cultural_subset = slice.to_a.map{ |x| @cultural[x] }
			new_cultural = @cultural - cultural_subset
			economy_subset = slice.to_a.map{ |x| @economy[x] }
			new_economy = @economy - economy_subset
			politics_subset = slice.to_a.map{ |x| @politics[x] }
			new_politics = @politics - politics_subset
			science_subset = slice.to_a.map{ |x| @science[x] }
			new_science = @science - science_subset
			war_subset = slice.to_a.map{ |x| @war[x] }
			new_war = @war - war_subset
			
			file.write "Training subset ##{i+1}...\n"
			@bc = Classifier::Bayes.new('accidents', 'crime', 'cultural', 'economy', 'politics', 'science', 'war')
			new_accidents.each { |x| @bc.train_accidents x }
			new_crime.each { |x| @bc.train_crime x }
			new_cultural.each { |x| @bc.train_cultural x }
			new_economy.each { |x| @bc.train_economy x }
			new_politics.each { |x| @bc.train_politics x }
			new_science.each { |x| @bc.train_science x }
			new_war.each { |x| @bc.train_war x }
			
			file.write "Testing classification of subset #{i+1}...\n"
			categories.each do |c|
				file.write "\n\t#{c.capitalize} test:\n"
				eval("#{c}_subset").each do |x|
					file.write "\t\tclassified as '#{self.classify x}': #{x}\n" rescue nil
				end
			end
			
		end
	
	end
	
end
