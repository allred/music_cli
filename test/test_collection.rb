require_relative 'test_helper'
require 'collection'

class CollectionTest < Minitest::Test
  def setup
    @collection = Collection.new
  end

  def test_default_container_is_hash
    assert_kind_of Hash, @collection.collection
  end

  def test_default_container_is_empty
    assert_empty @collection.collection
  end
end
