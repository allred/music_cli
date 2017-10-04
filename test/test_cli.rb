require_relative 'test_helper'
require 'cli'

class CliTest < Minitest::Test
  def setup
    @cli = Cli.new
    @command = "./music"
    @title = "Some Test Title"
    @artist = "Some Test Artist"
  end

  def test_add_valid
    assert_equal %Q%Added "#{@title}" by #{@artist}%, @cli.add(%Q%add "#{@title}" "#{@artist}"%)
    assert_equal 1, @cli.music.size
  end

  def test_add_invalid
    refute_equal %Q%Added "#{@title}" by #{@artist}%, @cli.add(%Q%add "#{@title}" #{@artist}%)
    assert_equal 0, @cli.music.size
  end

  def test_add_prevent_dupe
    assert_equal %Q%Added "#{@title}" by #{@artist}%, @cli.add(%Q%add "#{@title}" "#{@artist}"%)
    assert_equal %Q%Duplicate title "#{@title}" was not added%, @cli.add(%Q%add "#{@title}" "#{@artist}"%)
    assert_equal 1, @cli.music.size
  end

  def test_show_all
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}" "#{@artist}"%)
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}x" "#{@artist}x"%)
    shown = @cli.show("show all")
    assert_equal 2, shown.length
  end

  def test_show_all_by_valid
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}" "#{@artist}"%)
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}x" "#{@artist}"%)
    shown = @cli.show(%Q%show all by "#{@artist}"%)
    assert_equal 2, shown.length
  end

  def test_show_all_by_invalid
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}" "#{@artist}"%)
    shown = @cli.show(%Q%show all by%)
    assert_equal 0, shown.length
  end

  def test_show_unplayed
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}" "#{@artist}"%)
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}x" "#{@artist}"%)
    shown = @cli.show(%Q%show unplayed%)
    assert_equal 2, shown.length
  end

  def test_show_unplayed_by_valid
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}" "#{@artist}"%)
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}x" "#{@artist}"%)
    shown = @cli.show(%Q%show unplayed by "#{@artist}"%)
    assert_equal 2, shown.length
  end

  def test_show_unplayed_by_invalid
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}" "#{@artist}"%)
    shown = @cli.show(%Q%show unplayed by%)
    assert_equal 0, shown.length
  end

  def test_play_valid
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}" "#{@artist}"%)
    assert_equal 1,  @cli.show(%Q%show all by "#{@artist}"%).length
    @cli.play(%Q%play "#{@title}"%)
    @cli.show("show all").each do |e|
      assert_match %r%\(played\)%, e
    end
  end

  def test_play_invalid
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}" "#{@artist}"%)
    assert_equal 1,  @cli.show(%Q%show all by "#{@artist}"%).length
    @cli.play(%Q%play #{@title}%)
    @cli.show("show all").each do |e|
      refute_match %r%\(played\)%, e
    end
  end

  def test_quit
      assert_raises SystemExit do
        @cli.quit
      end
  end

  def test_puts_cli
    string = "howdy"
    out, err = capture_io do
      @cli.puts_cli(string)
    end
    assert_match %r%#{string}%, out

    array = ["hi", "there"]
    out, err = capture_io do
      @cli.puts_cli(array)
    end
    array.each do |i|
      assert_match %r%#{i}%, out
    end
  end

  def test_command_compile
    _ = %x(ruby -c #{@command})
    assert $?.success?
  end

end
