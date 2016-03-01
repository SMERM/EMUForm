class Forgery::Basic

  #
  # select a random number that is not included in an array passed as argument
  # 
  # options:
  #
  # * all the options of Forgery(:basic).number, plus
  # * :num_of_attempts (default: Forgery::Basic::DEFAULT_NUM_OF_ATTEMPTS)
  #
  # raise a TooManyAttempts exception if a limit (passed as a :num_of_attempts
  # option, or 50 by default) is exceeded
  #
  class TooManyAttempts < StandardError; end
  DEFAULT_NUM_OF_ATTEMPTS = 50

  def self.unique_number(array, options = {})
    n_of_attempts = options.delete(:num_of_attempts) || DEFAULT_NUM_OF_ATTEMPTS
    n = nil; x = 0
    while x < n_of_attempts
      n = self.number(options)
      break unless array.include?(n)
      x += 1
    end
    raise TooManyAttempts, "Number of attempts in finding a unique number (#{n_of_attempts}) exceeded" unless n
    n
  end

end
