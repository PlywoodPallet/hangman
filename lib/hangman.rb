# select a random word between 5-12 characters long

# function to render the current state of the game (_ r o g r a _ _ i n g) and the remaining number of guesses
# player can guess one letter or entire word
# 8 wrong guesses triggers end of game
# Implement last: at any time, user can save the state of the game (name: timestamp of when the game was saved). At the beginning of the game, an option to start a new game or load a previous one

# an array of letters. If "_" then the letter is 
class Game

  # number of total guesses a player can make
  $num_guesses = 8

  def initialize
    @game_board = []
    @num_guesses_remaining = $num_guesses
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

  # choose a random word between 5 and 12 characters, inclusive
  def choose_random_word(dictionary_array)
    random_index = rand(1...dictionary_array.length)
    until (dictionary_array[random_index].length >= 5 && dictionary_array[random_index].length <= 12) 
      random_index = rand(1...dictionary_array.length)
    end
    dictionary_array[random_index]
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

  def render_board
    puts @game_board.join(' ')
    puts ""
    puts "#{@num_guesses_remaining} guesses remain"
  end

  def play_game
    dictionary_array = load_dictionary_words("../dictionary.txt")
    random_word = choose_random_word(dictionary_array)
    @game_board = generate_board(random_word)
    render_board
  end

  def play_round

  end

end


# I hope not to need this class, but just in case I will define it here as a reminder if I do
class Board

end

class Cell
  attr_accessor :revealed
  
  # A cell is not revealed by default
  def initialize(letter, revealed = false)
    @letter = letter
    @revealed = revealed
  end

  # If a cell is revealed, return the letter. Otherwise, return "_"
  def to_s
    if revealed
      @letter
    else
      "_"
    end
  end
end

a_game = Game.new
a_game.play_game