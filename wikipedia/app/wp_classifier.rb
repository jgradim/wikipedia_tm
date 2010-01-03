require 'rubygems'
require 'stemmer'
require 'classifier'

class WPClassifier

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
		@accidents.each { |x| @bc.train_accidents x }
		@crime.each { |x| @bc.train_crime x }
		@cultural.each { |x| @bc.train_cultural x }
		@economy.each { |x| @bc.train_economy x }
		@politics.each { |x| @bc.train_politics x }
		@science.each { |x| @bc.train_science x }
		@war.each { |x| @bc.train_war x }
	end
	
	def classify(sentence)
		@bc.classify sentence
	end

end
