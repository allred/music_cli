require_relative 'test_helper'
require 'collection'

class CollectionTest < Minitest::Test
  def setup
    @collection = Collection.new
  end

  def test_default_is_empty
    assert_empty @collection.collection
  end

  def test_create
    @collection.create({some: "thing"})
    assert_equal @collection.size, 1
  end

  def test_create_bad_type_array
    assert_raises TypeError do
      @collection.create(['hi', 'there'])
    end
  end

  def test_read_all
    @collection.create({some: "thing"})
    @collection.create({some: "otherthing"})
    result = @collection.read('all')
    assert_equal result.keys.length, 2
  end

  def test_read_one_item
    query = {test1: "this"}
    @collection.create(query)
    @collection.create({test2: "that"})
    result = @collection.read(query)
    assert_equal result, [query]
  end

  def test_read_multi_item
    query = {"artist": "Megadeth"}
    @collection.create({artist: "Megadeth", title: "Rust In Peace"})
    @collection.create({artist: "Warbringer", title: "War Without End"})
    @collection.create({artist: "Megadeth", title: "Youthanasia"})
    assert_equal 2, @collection.read({"artist": "Megadeth"}).length
    assert_equal 0, @collection.read({"artist": "Milli Vanilli"}).length
    assert_equal 1, @collection.read({title: "War Without End", artist: "Warbringer"}).length
  end

  def test_query_length_longer_than_doc
    query = {one: 1, two: 2, three: 3}
    @collection.create({one: 1, two: 2})
    result = @collection.read(query)
    assert_equal result.length, 0
  end

end
