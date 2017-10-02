require_relative 'collection'

class MusicCollection < Collection

  def add(item)
    raise TypeError unless item.is_a? Hash

    # ensure no duplicate titles

    if read({title: item.fetch(:title)}).length > 0
      return nil
    end
    create(item)
  end

end
