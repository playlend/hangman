class Game
	attr_accessor :dictionary, :word, :guess, :misses, :show_word

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
		puts "Attempt number #{attempt+1}"
		show(@show_word)
		print "Guess a letter: "
		@guess = gets.chomp
		p @guess
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
				@show_word[counter] = @word[counter]

			elsif @word[counter] != @guess
				counter2 = counter2 + 1
			end
			
		end

		if counter1 == counter2
			@misses.push(@guess)
		end
		

	end



	def game_on
		attempt = 0
		
		while !won && (attempt <= @word.length+1)
		
			prompt(attempt)
			
			check_guess

			attempt = attempt + 1
		
		end

	end	

end

game1 = Game.new