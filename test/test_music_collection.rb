require_relative 'test_helper'
require 'music_collection'

class MusicCollectionTest < Minitest::Test
  def setup
    @mc = MusicCollection.new
  end

  def test_add_same_title_does_not_dupe
    @mc.add({artist: "A", title: "A"})
    @mc.add({artist: "B", title: "A"})
    assert_equal 1, @mc.size 
  end

  def test_show_all
    @mc.add({artist: "Meshuggah", title: "Nothing"})
    assert_equal 1, @mc.show('all').length
  end

end
