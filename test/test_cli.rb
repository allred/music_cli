require_relative 'test_helper'
require 'cli'

class CliTest < Minitest::Test
  def setup
    @cli = Cli.new
    @command = "./music"
    @title = "Some Test Title"
    @artist = "Some Test Artist"
  end

  def teardown
  end

  def test_add_valid
    assert_equal %Q%Added "#{@title}" by #{@artist}%, @cli.add(%Q%add "#{@title}" "#{@artist}"%)
    assert_equal 1, @cli.music.size
  end

  def test_add_invalid
    refute_equal %Q%Added "#{@title}" by #{@artist}%, @cli.add(%Q%add "#{@title}" #{@artist}%)
    assert_equal 0, @cli.music.size
  end

  def test_show_all
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}" "#{@artist}"%)
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}x" "#{@artist}x"%)
    shown = @cli.show("show all")
    assert_equal 2, shown.length
  end

  def test_show_all_by
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}" "#{@artist}"%)
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}x" "#{@artist}"%)
    assert_match %r%Added%, @cli.add(%Q%add "#{@title}x" "#{@artist}x"%)
    shown = @cli.show(%Q%show all by "#{@artist}"%)
    assert_equal 2, shown.length
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
