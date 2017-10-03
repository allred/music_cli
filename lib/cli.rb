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

  def puts_cli(input)
    if input.is_a? String
      puts "\n#{input}\n\n"
    elsif input.is_a? Array
      print "\n"
      input.each do |l|
        puts l
      end
      puts "\n"
    end
  end

  def handle_io(input)
    input_stripped = input.strip
    input_words = input_stripped.split(/\s+/)
    if input_words[0] =~ /^quit$/i
      puts_cli "Bye!"
      quit
    elsif input_words[0] =~ /^add/i
      puts_cli add(input_stripped)
    elsif input_words[0] =~ /^play$/i
      puts_cli play(input_stripped)
    elsif input_words[0] =~ /^show$/i
      puts_cli show(input_stripped)
    end
  end

  def add(input)
    begin
      command, title, artist = /^(\S+)\s+"(.*?)".*"(.*?)"/.match(input).captures
      @music.add({title: title, artist: artist})
      return %Q%Added "#{title}" by #{artist}%
    rescue
      return %Q%Failed to add item, syntax is: add "title" "artist"%
    end
  end

  def play
  end

  def show(input)
    formatted = []
    docs = []
    words = input.split(/\s+/)

    # show all

    if words[1] =~ /^all$/i && words[2] == nil
      @music.read('all').each do |doc|
        docs.push(doc)
      end

    # show all by

    elsif words[1] =~ /^all$/i && words[2] =~ /^by$/i
      regex = %r/^.*"(.*?)"/
      if regex.match?(input) && regex.match(input).captures.length > 0
        artist = regex.match(input).captures[0]
        @music.read({artist: artist}).each do |doc|
          docs.push(doc)
        end
      end

    # show unplayed

    elsif words[1] =~ /^unplayed$/i && words[2] == nil
      @music.read({played: false}).each do |doc|
        docs.push(doc)
      end

    # show unplayed by

    elsif words[1] =~ /^unplayed$/i && words[2] =~ /^by$/i
      regex = /^.*"(.*?)"/
      if regex.match?(input) && regex.match(input).captures.length > 0
        artist = regex.match(input).captures[0]
        @music.read({artist: artist, played: false}).each do |doc|
          docs.push(doc)
        end
      end
    end

    # format documents for output

    docs.each do |doc|
      entry = doc.values[0]
      line = %Q%"#{entry[:title]}" by #{entry[:artist]}%
      if words[1] == 'all'
        line += " (#{entry[:played] ? "played" : "unplayed"}) "
      end
      formatted.push(line)
    end
    return formatted
  end

  def quit
    exit 0
  end
end
