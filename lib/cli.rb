require_relative 'music_collection'

class Cli
  def initialize(args={})
    @music = MusicCollection.new
  end

  def run() 
    STDOUT.sync = true
    puts_cli "Welcome to your music collection!"
    while true
      print "> "
      input_words = gets.strip.split(/\s+/)
      output = handle_input_words(input_words)
      puts_cli output
    end
  end

  def puts_cli(string)
    puts "\n#{string}\n\n"
  end

  def handle_input_words(input)
    puts "DEBUG: #{input}"
    if input[0] =~ /^quit$/i
      puts_cli "Bye!"
      quit
    end
  end

  def quit
    exit
  end
end
