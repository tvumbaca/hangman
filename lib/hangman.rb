
class Game

  attr_accessor :board

  def initialize
    @word = secret_word
    @board = @word.map { |i| i = "_" }
    @all_letters = []
    @wrong_letters = []
    @win = false
  end

  def secret_word
    dict = File.open("../5desk.txt", "r")
    lines = dict.readlines
    word = valid_words(lines).sample.upcase.split("")
  end

  def valid_words(line)
    arr = []
    line.each do |word|
      if word.strip.length.between?(5, 12)
        arr << word.strip
      end
    end
    arr
  end

  def intro
    puts "\nWould you like to play HANGMAN?\nType 'Y' (yes) or 'N' (no)"
    answer = gets.chomp.downcase
    if answer == "y"
      puts "\nGreat! LET'S PLAY!"
    elsif answer == "n"
      abort("\nOk. See you later!\n")
    else
      puts "\nThat is not a valid answer."
      intro
    end
  end

  def check_letter(letter)
    if @all_letters.any? { |item| item == letter }
      puts "\nThe letter '#{letter}' has already been chosen. Please try again." 
    elsif @word.any? { |item| item == letter }
      @word.each_with_index { |item, index|
        if item == letter
          @board[index] = letter
        end
      }
      @all_letters << letter
    else
      puts "\nThe letter '#{letter}' is not in the secret word. Please try again."
      @wrong_letters << letter
      @all_letters << letter
    end
    win?
  end

  def print_board
    puts "\n #{@board.join(" ").to_s}"
    puts "\nIncorrect guesses: #{@wrong_letters.join(",")}\t #{6 - @wrong_letters.length} guesses remaining."
  end

  def win?
    if @word == @board
      puts "\nYOU WON!!!"
      puts "\nThe secret word is: #{@word.join}\n\n"
      @win = true
    elsif @wrong_letters.length == 6
      puts "\nYou are out of guesses. GAME OVER!"
      puts "\nThe secret word is: #{@word.join}\n\n"
      @win = true
    end
  end

  def turn
    print_board
    puts "\nPick a letter.\n"
    letter = gets.chomp.upcase
    check_letter(letter)
  end

  def play
    intro
    # loop for taking turns until win or lose.
    until @win do 
      turn
    end
  end

end

a = Game.new
a.play




# player gets six guesses to figure out the secret word

# during each turn 
# display the underscores for each letter of the word length
#  -- update the underscores with the correctly guessed letters
# display the number of remaining guesses
# display the incorectly guessed letters