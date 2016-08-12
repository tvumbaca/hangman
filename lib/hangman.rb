require "yaml"

class Game

  def initialize
    @word = secret_word
    @board = @word.map { |i| i = "_" }
    @all_letters = []
    @wrong_letters = []
    @win = false
  end

  def intro
    puts "\nWould you like to play HANGMAN?\nType 'Y' (yes), 'N' (no), or 'LOAD' to load a previously saved game."
    answer = gets.chomp.downcase
    if answer == "load"
      puts "\nThis is where the last saved game left off."
      load_game
    elsif answer == "y"
      puts "\nGreat! LET'S PLAY!"
      play
    elsif answer == "n"
      abort("\nOk. See you later!\n")
    else
      puts "\nThat is not a valid answer."
      intro
    end
  end

  # ------------------- protected methods ----------------------
  protected

  def play
    # loop for taking turns until win or lose.
    until @win do 
      turn
    end
  end

  # ------------------- Private methods ----------------------
  private

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

  def check_letter(answer)
    if answer == "SAVE"
      save_game
      puts "\nThe game has been saved."
      resume_game?
    elsif @all_letters.any? { |item| item == answer }
      puts "\nThe letter '#{answer}' has already been chosen. Please try again." 
    elsif @word.any? { |item| item == answer }
      @word.each_with_index { |item, index|
        if item == answer
          @board[index] = answer
        end
      }
      @all_letters << answer
    else
      puts "\nThe letter '#{answer}' is not in the secret word. Please try again."
      @wrong_letters << answer
      @all_letters << answer
    end
    win?
  end

  def resume_game?
    puts "\nWould you like to continue playing this game?"
    puts "Type 'Y' to continue, type 'N' to exit game."
    input = gets.chomp.upcase
    if input == "N"
      abort("\nThe game has ended. Thanks for playing HANGMAN!\n")
    end
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

  def save_game
    Dir.mkdir('saved_games') unless Dir.exist? 'saved_games'
    filename = 'saved_games/saved.yaml'
    File.open(filename, 'w') { |file| file.puts YAML.dump(self) } 
  end

  def load_game
    saved_file = File.read('saved_games/saved.yaml')
    saved_game = YAML.load(saved_file)
    saved_game.play
  end

  def turn
    print_board
    puts "\nPick a letter, or type 'save' to save the game.\n"
    answer = gets.chomp.upcase
    check_letter(answer)
  end

end

hangman = Game.new
hangman.intro
