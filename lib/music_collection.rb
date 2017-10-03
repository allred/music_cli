require_relative 'collection'

class MusicCollection < Collection

  def add(item)

    # ensure no duplicate titles

    if read({title: item.fetch(:title)}).length > 0
      return nil
    end

    # default to played = false

    unless item.has_key? :played
      item.merge!({played: false})
    end
    create(item)
  end

  def show(query)
    read(query)
  end

  def play()
  end

end
