require_relative 'music_collection'

class Cli
  attr_reader :music

  def initialize(args={})
    @music = MusicCollection.new
  end

  def run() 
    STDOUT.sync = true
    puts_cli "Welcome to your music collection!"
    while true
      print "> "
      output = handle_io(gets)
      puts_cli output
    end
  end

  def puts_cli(string)
    puts "\n#{string}\n\n"
  end

  def handle_io(input)
    input_stripped = input.strip
    input_words = input_stripped.split(/\s+/)
    if input_words[0] =~ /^quit$/i
      puts_cli "Bye!"
      quit
    elsif input_words[0] =~ /^add/i
      puts_cli(add(input_stripped))
    elsif input_words[0] =~ /^play$/i
      play(input_stripped)
    elsif input_words[0] =~ /^show$/i
      show(input_stripped).each do |s|
        puts s
      end
    end
  end

  def add(input)
    command, title, artist = /^(\S+)\s+"(.*?)"\s+"(.*?)"/.match(input).captures
    @music.add({title: title, artist: artist})
    return %Q%Added "#{title}" by #{artist}%
  end

  def play
  end

  def show(input)
    formatted = []
    docs = []
    words = input.split(/\s+/)
    if words[1] =~ /^all$/i
      @music.read('all').each do |index, doc|
        docs.push(doc)
      end
    elsif words[1] =~ /^unplayed$/i
      @music.read({unplayed: true}).each do |index, doc|
      end
    end

    # format

    docs.each do |doc|
      line = %Q%"#{doc[:title]}" by #{doc[:artist]}%
      formatted.push(line)
    end
    return formatted
  end

  def quit
    exit 0
  end
end
