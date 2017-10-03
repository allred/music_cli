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
    assert_equal 2, result.length
  end

  def test_read_one_item
    query = {test1: "this"}
    @collection.create(query)
    @collection.create({test2: "that"})
    result = @collection.read(query)
    assert_equal result, [{1 => query}]
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
    results = @collection.read(query)
    assert_equal results.length, 0
  end

  def test_update
    query = {one: 1, two: 2}
    @collection.create(query)
    assert_equal 1, @collection.size
    result_update = @collection.update(query, {one: 3})
    result_read = @collection.read({two: 2})
    expected = [{1 => {one: 3, two: 2}}]
    assert_equal expected, result_read
  end

end
