class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service
  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end

  attr_accessor :word, :guesses, :wrong_guesses

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end
  
  def guess(letters)
    raise ArgumentError if letters == "" 
    raise ArgumentError if letters !~ /[a-zA-Z]/
    letters.downcase!
      if  @word.include?(letters) 
        if !@guesses.include?(letters)
          @guesses << letters
        else
          return false
        end
      else
        if !@wrong_guesses.include?(letters)
          @wrong_guesses << letters
        else
          return false
        end
      end
  end
  
  def check_win_or_lose
    if (@wrong_guesses.length == 7) 
      :lose
    elsif (!self.word_with_guesses.include?("-"))
      :win
    else
      :play
    end
  end
  
  def word_with_guesses
    guesses_list = @guesses.to_s
    guesses_rx = /[^ #{guesses_list}]/
    @masked = @word.gsub(guesses_rx, "-")
    @masked.scan(/[a-z\-]/).join
  end

end
