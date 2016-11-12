class Mastermind

  attr_reader :code, :input, :solved

  def initialize
  	puts introduction
  	game_type = gets.chomp.downcase
  	if game_type == "make"
  	  new_game_computer
  	elsif game_type == "guess"
  	  new_game_player
  	else
  	  puts "Input invalid. Please try again."
  	end
  end
  
  def new_game_player
  	create_new_code 
  	rounds = 0
    until @code == @input || rounds == 12
      valid_input = false
      puts "Please enter your next guess."
      until valid_input
        colours = gets.chomp
        @input = colours.split(',')
        input_to_sym(@input)
      	if is_input_valid(@input)
      	  valid_input = true
      	else
      	  puts "Invalid input. Please enter another combination."
      	end
      end
      print_feedback
      rounds += 1
    end
    if @code == @input
      puts "Congratulations you won!"
    else
      puts "Sorry you ran out of guesses. You lost."
    end
  end

  def new_game_computer
  	puts "Please enter your 4 colour code using the colours red,blue,green,yellow,white,black."
  	valid_input = false
  	until valid_input
  	  colours = gets.chomp
  	  @code = colours.split(',')
  	  input_to_sym(@code)
  	  if is_input_valid(@code)
  	  	valid_input = true
  	  else
  	    puts "Invalid input. Please enter another combination."
  	  end
  	end
  	rounds = 0
  	@input = [nil,nil,nil,nil]
  	@solved = [nil,nil,nil,nil]
  	col_wrong_spot = nil
  	until @code == @input || rounds == 12
      @input.each_with_index do |i,iindex|
      	if i == @code[iindex]
      	  @input[iindex] = i
      	  @solved[iindex] = i
      	else
      	  if col_wrong_spot == nil
      	    @input[iindex] = random_colour
      	  else
      	  	@input[iindex] = col_wrong_spot
      	  	col_wrong_spot = nil
      	  end
      	end
      	if colour_in_code(i,@code)
      	  @code.each_with_index do |c,cindex|
      	  	if i == c
      	  	  if @solved[cindex] == nil
      	  	  	col_wrong_spot = i
      	  	  end
      	  	end
      	  end
      	end
  	  end
  	rounds += 1
  	end
    if @code == @input
      puts "The computer guessed your code in #{rounds} rounds!"
    else
      puts "The computer could not guess your code!"
      puts "Your code was: #{@code}.\nThe computer guessed: #{@input}.\n"
    end
  end

  private

  def colour_in_code(colour,code)
    code.any? do |i|
      i == colour 
    end
  end

  def is_input_valid(input)
  	input.all? do |i|
  	  i == :red || i == :blue || i == :black || i == :green || i == :white || i == :yellow
  	end
  end

  def introduction
  	puts "Hello, welcome to Mastermind! In this game, you use the colours red, blue, green, yellow, white, and black to create a 4 item code. You have 12 tries to guess the code. After each try you'll be given feedback on which colours of the code are correct and which are correct but in the wrong place. Type 'guess' if you'd like to guess the code or 'make' if you want to make a code for the computer to guess. When entering a code, enter the full name of each colour separated by commas."
  end

  def create_new_code
    @code = []
    4.times do
      @code.push(random_colour)
    end
  end

  def random_colour
  	colours = [:red,:yellow,:white,:black,:green,:blue]
  	colours.sample
  end

  def input_to_sym(input)
    input.map! do |i|
      i.downcase.to_sym
    end
  end

  def print_feedback
  	correct_placement = 0
  	wrong_placement = 0
  	checked = []
    @input.each_with_index do |i,iindex|
      if i == @code[iindex]
      	correct_placement += 1
      	if checked[iindex] == i
      	  wrong_placement -= 1
      	else
      	  checked[iindex] = i
      	end
      else
        @code.each_with_index do |c,cindex|
      	  if i == c && i != @code[iindex] && checked[cindex] != c
      	  	wrong_placement += 1
      	  	checked[cindex] = c
      	  end
      	end
      end
    end
    puts "\nThere are #{correct_placement} in the correct spot."
    puts "There are #{wrong_placement} that have the right colour in the wrong spot."
  end
end

Mastermind.new