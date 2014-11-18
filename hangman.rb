class Hangman
  MAX_GUESSES = 6

  def initialize(guessing_player, checking_player)
    @guesser = guessing_player
    @checker = checking_player
  end

  def play
    begin
      @checker.pick_secret_word
    rescue
      puts "bad secret word length."
      retry
    end

    @checker.print_rep

    wrong_guesses = 0
    positions = nil

    while wrong_guesses < MAX_GUESSES
      begin
        guess = @guesser.get_guess(@checker.secret_word_length, positions)
      rescue
        puts "something went wrong."
        retry
      end

      begin
        positions = @checker.do_guess(guess)
      rescue
        puts "invalid indices"
        retry
      end

      if (positions)
        return if @checker.check_win
        @guesser.handle_guess_response(true)
      else
        wrong_guesses += 1
        @guesser.handle_guess_response(false)
      end

      @checker.print_rep
    end

    @guesser.lose
    puts "The word was: #{@checker.secret_word}"
    nil
  end
end




class HumanPlayer
  attr_reader :secret_word_length, :secret_word

  def initialize
    @secret_word = "Only Human Knows"
  end

  def pick_secret_word
    puts "Enter the length of the secret word: "
    @secret_word_length = Integer(gets.chomp)
    raise unless @secret_word_length.between?(1,30)
    @word_rep = Array.new(@secret_word_length, nil)
  end


  def get_guess(length, positions)
    puts "Give the computer your letter guess:"
    input = gets.chomp
    raise unless input =~ /^[a-zA-Z]$/
  end


  def do_guess(guess)
    puts "Computer has guessed letter #{guess}."
    puts "Please give indexes of letter: "

    correct_guesses = gets.chomp.split(/\s+/).map(&:to_i)
    raise if correct_guesses.any? {|guess| !guess.between?(0,@secret_word_length-1)}

    return nil if correct_guesses == []

    correct_guesses.each { |i| @word_rep[i] = guess }
    correct_guesses
  end

  def check_win
    if @word_rep.include?(nil)
      false
    else
      print "The word was: "
      print_rep
      puts "CPU wins!"
      true
    end
  end

  def handle_guess_response(result)
  end

  def print_rep
    puts (@word_rep.map { |char|  char.nil? ? "_" : char }).join("")
  end

  def lose
    puts "Human Loses!"
  end
end

class CompPlayer
  attr_reader :secret_word_length, :secret_word

  def initialize
    @dictionary = File.readlines('dictionary.txt').map{ |line| line.chomp }
    @last_guess = ''
    @last_guess_flag = false
    @first_time_flag = true
    @good_words = []
    @letter_freq = {}
    @used_letters = []
  end

  def pick_secret_word
    @secret_word = @dictionary.sample
    @word_rep = Array.new(@secret_word.length, nil)
    print "Comp has chosen a word of length: #{@secret_word.length}  "
    print_rep
  end

  def do_guess(guess)
    changes = false
    @secret_word.chars.each_index do |index|
      if @secret_word[index] == guess
        @word_rep[index] = guess
        changes = true
      end
    end
    return true if changes

    false
  end

  def check_win
    if @word_rep.include?(nil)
      false
    else
      print "The word was: "
      print_rep
      puts "Human Victory!"
      true
    end
  end


  def get_guess(length, positions)
    educated_guess(length, positions)
  end

  def handle_guess_response(result)
    @last_guess_flag = result
  end


  def print_rep
    puts (@word_rep.map { |char|  char.nil? ? "_" : char }).join("")
  end

  def lose
    puts "Computer Loses!"
  end

  private

  def educated_guess(length, positions)


    if @first_time_flag
      @good_words = @dictionary.select {|word| word.length == length}

      @letter_freq = find_letter_freq
      @last_guess = find_highest_freq
      @first_time_flag = false
      @used_letters << @last_guess
      @last_guess

    else
      if @last_guess_flag
        @good_words.select! do |word|
          positions.all? {|p| word[p] == @last_guess}
        end
        raise "LYING BASTARD" if @good_words.empty?


        @letter_freq = find_letter_freq
        @last_guess = find_highest_freq
        @used_letters << @last_guess
        @last_guess
      else
        @good_words.reject!{|word| word.include?(@last_guess)}
        raise "LYING BASTARD" if @good_words.empty?

        @letter_freq = find_letter_freq
        @last_guess = find_highest_freq
        @used_letters << @last_guess
        @last_guess
      end
    end
  end

  def find_letter_freq
    @letter_freq = Hash.new(0)
    @good_words.each do |word|
      word.each_char do |c|
        @letter_freq[c] += 1 unless @used_letters.include?(c)
      end
    end

    @letter_freq
  end

  def find_highest_freq
    @letter_freq.delete(@last_guess) unless @first_time_flag
    highest = @letter_freq.max_by{ |k,v| v }[0]


    highest

  end
end
