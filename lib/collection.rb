class Collection
  attr_accessor :collection
  attr_reader :id

  def initialize()
    @collection = {}
    @id = 0
  end

  def next_id
    return @id += 1
  end

  def create(document)
    raise TypeError unless document.is_a? Hash
    @collection[next_id] = document
  end

  def read(query)
    results = []
    @collection.each do |key, doc|
      if query == 'all'
        results.push(Hash[key, doc])
        next
      end


      # skip document if none of the query keys are in the document
      # or if the query has more keys than the document

      if (doc.keys & query.keys).length < 1 || query.keys.length > doc.keys.length
        next
      end

      # if the document exactly matches the query, add it to results
      # or ensure the key/values of query are found in the document and add it

      if doc == query
        results.push(Hash[key, doc])
      else
        query.keys.each do |qk|
          if doc.has_key?(qk) && doc.fetch(qk) == query.fetch(qk)
            results.push(Hash[key, doc])
          end
        end
      end
    end
    return results
  end

  def update(query, merge_hash)
    read(query).each do |r|
      r[r.keys[0]].merge!(merge_hash)
      @collection.merge!(r)
    end
  end

  def delete()
    raise NotImplementedError
  end

  def size()
    return @collection.keys.length
  end
end
