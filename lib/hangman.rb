# select a random word between 5-12 characters long

# function to render the current state of the game (_ r o g r a _ _ i n g) and the remaining number of guesses

# 8 wrong guesses triggers end of game
# Implement last: at any time, user can save the state of the game (name: timestamp of when the game was saved). At the beginning of the game, an option to start a new game or load a previous one

# an array of letters. If "_" then the letter is 

# TODO: If save_word is the chosen random word, choose another one

class Game

  # total guesses a player can make
  $num_guesses = 8

  # command that triggers serialization
  $save_word = 'SAVE'

  def initialize (game_board=[], game_word=nil, num_guesses_remaining=$num_guesses)
    @game_board = game_board
    @game_word = game_word # this variable is used to detect if the user guesses the whole word outright
    @num_guesses_remaining = num_guesses_remaining
  end

  # load all dictionary words from file into array
  def load_dictionary_words(path)
    dictionary_file = File.open(path, "r")
    dictionary_array = []

    dictionary_file.each do |row|
      dictionary_array.push(row.strip)
    end

    dictionary_array
  end

  # Choose a random word between 5 and 12 characters, inclusive. Returned word is always upper case
  def choose_random_word(dictionary_array)
    random_index = rand(1...dictionary_array.length)
    until (dictionary_array[random_index].length >= 5 && dictionary_array[random_index].length <= 12) 
      random_index = rand(1...dictionary_array.length)
    end
    dictionary_array[random_index].upcase
  end

  # take a word and create a board with Cell objects for each character, with no chars revealed
  # All letters in the board are uppercase
  def generate_board(word)
    board = []
    
    word_array = word.split('')
    word_array.each do |char|
      board.push(Cell.new(char.upcase))
    end

    board
  end

  # display the current state of the game
  def render_board
    puts @game_board.join(' ')
    puts ''
    puts "#{@num_guesses_remaining} guesses remain"
    puts ''
  end

  # if letter exists on the board, reveal it
  def board_reveal_letter(letter)
    @game_board.map do |cell|
      if cell.letter == letter
        cell.revealed = true
      end
    end

  end

  # reveal all letters, used when user guesses whole word outright
  def board_reveal_all_letters
    @game_board.map {|cell| cell.revealed = true}
  end

  # play one round of the game
  # if "save" is entered, save the game
  # player can guess one letter or entire word
  
  def play_round
    # loop until the player guesses the word or runs out of guesses
    until player_win? || @num_guesses_remaining <= 0
      # add input processing: must be a single letter, case insensitive
      
      puts 'Enter a letter or whole word: '
      # puts "Enter #{$save_word} to save the state of the game"
      input = gets.chomp.strip.upcase
      puts ''

      # If save_word was entered, serialize the game state
      # if input == $save_word
      #   puts 'save game code here'
      #   next
      # Allow the user to guess the entire word outright
      if input == @game_word
        board_reveal_all_letters
      # If input is a single letter, reveal any matching letters in the word
      elsif input.length == 1
        board_reveal_letter(input)
      end

      @num_guesses_remaining -= 1
      
      render_board
    end
  end

  # if all cells have been revealed, then return true
  def player_win?
    num_revealed = @game_board.select {|cell| cell.revealed == true}.length

    num_revealed == @game_board.length ? true : false
  end


  # if a save game exists, ask the user if they want to load it
  # during play_round, ask user to enter save_word to trigger a save
  # save should be named based on timestamp
  def play_game
    dictionary_array = load_dictionary_words('../dictionary.txt')
    random_word = choose_random_word(dictionary_array)
    @game_board = generate_board(random_word)
    @game_word = random_word

    render_board
    play_round

    if player_win?
      puts 'Congratulations, you guessed the word!'
    else
      puts 'Dang! You ran out of guesses'
    end
  end
end



class Cell
  attr_accessor :revealed
  attr_reader :letter
  
  # A cell is not revealed by default
  def initialize(letter, revealed=false)
    @letter = letter
    @revealed = revealed
  end

  # If a cell is revealed, return the letter. Otherwise, return "_"
  def to_s
    if revealed
      @letter
    else
      '_'
    end
  end
end

a_game = Game.new
a_game.play_game