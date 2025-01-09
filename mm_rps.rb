class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
  ROCK = ['scissors', 'lizard']
  PAPER = ['rock', 'spock']
  SCISSORS = ['paper', 'lizard']
  LIZARD = ['spock', 'paper']
  SPOCK = ['scissors', 'rock']

  def initialize(value)
    @value = value
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def scissors?
    @value == 'scissors'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def beats?(other_move)
    other_move = other_move.to_s
    return (ROCK.include?(other_move)) if rock?
    return (PAPER.include?(other_move)) if paper?
    return (SCISSORS.include?(other_move)) if scissors?
    return (LIZARD.include?(other_move)) if lizard?
    return (SPOCK.include?(other_move)) if spock?
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score, :stats, :games

  def initialize
    set_name
    set_score
    set_stats
    set_games
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      sleep 1
      puts "What's your name?"
      n = gets.chomp
      break unless n.downcase.chars.none?(/[a-z]/)

      puts "Please enter a valid name."
    end
    self.name = n.capitalize
  end

  def choose_dialog_one
    system("clear")
    sleep 1
    puts "Please choose rock, paper, scissors, lizard, or spock:"
  end

  def choose_dialog_two
    sleep 1
    puts "Sorry, invalid choice."
    sleep 1
  end

  def choose
    choice = nil
    loop do
      choose_dialog_one
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      choose_dialog_two
    end
    self.move = Move.new(choice)
  end

  def set_score
    self.score = 0
  end

  def set_stats
    self.stats = []
  end

  def set_games
    self.games = 0
  end
end

class Computer < Player
  def set_name
    self.name = ['R2', 'CHOP', 'HAL'].sample
  end

  def choose
    case name
    when 'R2'   # Every Choice
      self.move = Move.new(Move::VALUES.sample)
    when 'CHOP' # Scissors/Lizard/Spock
      self.move = Move.new(Move::VALUES[2..4].sample)
    when 'HAL'  # Rock/Paper/Scissors
      self.move = Move.new(Move::VALUES[0..2].sample)
    end
  end

  def set_score
    self.score = 0
  end

  def set_stats
    self.stats = []
  end

  def set_games
    self.games = 0
  end
end

class RPSGame
  attr_accessor :human, :computer

  RULES_1 = ["You will make a Choice,", "The Computer will make a Choice,",
             "Each Computer chooses differently.",
             "The Winner will score a Point,", "Unless there is a Tie.",
             "Three Points wins a Whole Game.",
             "You can play as long as you want.",
             "You will see how each Game is going,",
             "And who's won what as you go.",
             "You can see everything played at the end."]

  RULES_2 = ["Rock Breaks Scissors", "Scissors Cut Paper",
             "Paper Covers Rock", "Rock Crushes Lizard",
             "Lizard Poisons Spock", "Spock Melts Scissors",
             "Scissors Decapitate Lizard", "Lizard Eats Paper",
             "Paper Disproves Spock", "Spock Vaporizes Rock"]

  def initialize
    system("clear")
    puts "Hello Human!"
    sleep 1
    puts "Welcome to Rock, Paper, Scissors:"
    sleep 1
    puts "Featuring Lizard and Spock!"
    @human = Human.new
    @computer = Computer.new
    display_welcome_message
  end

  def display_return
    puts "Press 'Return' to exit."
    gets
  end

  def computer_bio(name)
    case name
    when 'R2'
      puts "R2 has a full toolkit."
    when 'CHOP'
      puts "CHOP is missing a few screws."
    when 'HAL'
      puts "HAL is more traditional."
    end
  end

  def display_rules(rules)
    rules.each do |rule|
      puts rule
      sleep 1
    end
    puts ''
    display_return
    system('clear')
  end

  def rules?
    answer = nil
    puts "Would you like to see the rules before we begin? (y/n)"
    loop do
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      y_or_n_dialog
    end
    system('clear')
    display_rules(RULES_1) if answer == 'y'
    display_rules(RULES_2) if answer == 'y'
  end

  def display_welcome_message
    puts "Hi #{human.name}!"
    sleep 1
    rules?
    puts "You will be playing against #{computer.name}."
    sleep 1
    computer_bio(computer.name)
    sleep 1
    puts "Good Luck!"
    sleep 1
  end

  def display_goodbye_message
    puts "Thank You So Much For Playing, #{human.name}!"
    sleep 2
    system("clear")
  end

  def display_moves
    sleep 1
    puts "#{human.name} chose: #{human.move}."
    puts "#{computer.name} chose: #{computer.move}."
    sleep 1
  end

  def add_stats
    human.stats << human.move.to_s
    computer.stats << computer.move.to_s
  end

  def convert_stats_array_to_hash(stats_array)
    hash = Hash.new(0)
    stats_array.each { |element| hash[element] += 1 }
    hash = hash.sort_by { |_k, v| v }.reverse
  end

  def convert_stats
    human.stats = convert_stats_array_to_hash(human.stats)
    computer.stats = convert_stats_array_to_hash(computer.stats)
  end

  def score_round
    add_stats
    if human.move.beats?(computer.move)
      human.score += 1
    elsif computer.move.beats?(human.move)
      computer.score += 1
    end
  end

  def display_winner
    if human.move.beats?(computer.move)
      puts "#{human.name} Won!"
    elsif computer.move.beats?(human.move)
      puts "#{computer.name} Won!"
    else
      puts "It's a Tie!"
    end
  end

  def display_score
    sleep 1
    puts "#{human.name}'s score: #{human.score}. " \
         "#{computer.name}'s score: #{computer.score}."
    sleep 1
  end

  def reset_scores
    human.score = 0
    computer.score = 0
  end

  def y_or_n_dialog
    sleep 1
    puts "Please input 'y' or 'n'."
    sleep 1
  end

  def display_stats(player)
    puts "#{player.name} won #{player.games} " \
         "game#{'s' if player.games != 1}, playing: "
    player.stats.each { |k, v| puts "   #{k}: #{v} time#{'s' if v != 1}" }
  end

  def display_stats_all
    display_stats(human)
    display_stats(computer)
    display_return
  end

  def ask_stats_loop
    convert_stats
    loop do
      puts "Would you like to see the game stats before you go? (y/n)"
      answer = gets.chomp
      return answer if ['y', 'n'].include?(answer.downcase)
      y_or_n_dialog
    end
  end

  def display_stats?
    sleep 1
    answer = ask_stats_loop
    system('clear')
    sleep 0.5
    display_stats_all if answer == 'y'
  end

  def ultimate_winner?
    if human.score == 3
      puts "#{human.name.upcase} WINS THE WHOLE GAME!"
      human.games += 1
      reset_scores
    elsif computer.score == 3
      puts "#{computer.name} WINS THE WHOLE GAME!"
      computer.games += 1
      reset_scores
    end
  end

  def play_again?
    answer = nil
    ultimate_winner?
    loop do
      puts "Would you like to play again, #{human.name}? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      y_or_n_dialog
    end
    answer == 'y'
  end

  def choices
    human.choose
    computer.choose
  end

  def play
    loop do
      choices
      display_moves
      score_round
      display_winner
      display_score
      break unless play_again?
    end
    display_stats?
    display_goodbye_message
  end
end

RPSGame.new.play
