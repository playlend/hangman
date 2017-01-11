require "yaml"

class Game
	attr_accessor :dictionary, :word, :guess, :misses, :show_word, :attempt, :saved_game

	def initialize
		@dictionary = File.readlines("dictionary.txt")
		random_word
		@guess = ""
		@misses = []
		@show_word = []
		(@word.length-1).times do |num|
			@show_word[num] = "_"
		end

	end

	def random_word
		@word = " "
		while !(@word.length >= 5 && @word.length <= 12)
			@word = @dictionary[rand(0..@dictionary.length-1)]
		end

	end	

	def show(show_word)
		puts "Word: #{@show_word}"
	end

	def prompt(attempt)
		puts "Attempt number #{@attempt+1}"
		show(@show_word)
		print "Guess a letter: "
		@guess = gets.chomp
		puts "Misses: #{@misses}"
	end

	def won
		@show_word.join("") == @word.chomp
	end	

	def check_guess
		counter1 = 0
		counter2 = 0
		(@word.length-1).times do |counter|
			counter1 = counter1 + 1
			if @word[counter] == @guess
				puts "You got it! There is a letter '#{@word[counter]}' in the word."
				@show_word[counter] = @word[counter]

			elsif @word[counter] != @guess
				counter2 = counter2 + 1
			end
			
		end

		if counter1 == counter2
			@misses.push(@guess)
			puts "I'm sorry, letter '#{@guess}' is not present in the word."
		end
		

	end

	def yaml_dump
		File.open("game.yaml", "w") do |file|
			file.puts YAML::dump(self)
		end
	end

	def yaml_load
		File.open("game.yaml", "r") do |obj|
			@saved_game=YAML::load(obj)
			
		end
	end


	def new_or_saved
		print "Enter 1 start a new game, enter 2 to load saved game: "
		answer = gets.chomp
		answer = answer.to_i
	end

	def save_game
		print "Enter 1 to save the game, enter 2 to quit, or hit 'enter' to continue: "
		answer = gets.chomp
		answer = answer.to_i

	end


	def new_game
		@attempt = 0
		
		while !won && (@attempt <= @word.length+1)
			
			case save_game
				when 1
					yaml_dump
				when 2
					exit
			end

			prompt(@attempt)
			
			check_guess

			@attempt = @attempt + 1
		
		end

	end	

	
	def load_game
		if yaml_load
		
			while !(@saved_game.show_word.join("") == @saved_game.word.chomp) && (@saved_game.attempt <= @saved_game.word.length+1)
			
				#prompt
					puts "Attempt number #{@saved_game.attempt+1}"
					puts "Word: #{@saved_game.show_word}"
					print "Guess a letter: "
					@saved_game.guess = gets.chomp
					puts "Misses: #{@saved_game.misses}"
				#prompt
				
				#check guess
					counter1 = 0
					counter2 = 0
					(@saved_game.word.length-1).times do |counter|
						counter1 = counter1 + 1
						if @saved_game.word[counter] == @saved_game.guess
							puts "You got it! There is a letter '#{@saved_game.word[counter]}' in the word."
							@saved_game.show_word[counter] = @saved_game.word[counter]

						elsif @saved_game.word[counter] != @saved_game.guess
							counter2 = counter2 + 1
						end
					
					end

					if counter1 == counter2
						@saved_game.misses.push(@saved_game.guess)
						puts "I'm sorry, letter '#{@saved_game.guess}' is not present in the word."
					end		

				#check guess

				@saved_game.attempt = @saved_game.attempt + 1
		
			end
		else
			puts "There are no saved games to load. Bye!"
			exit
		end
	end

	def start
		case new_or_saved
			when 1
				new_game
			when 2
				load_game
		end
	end


end

game1 = Game.new
game1.start