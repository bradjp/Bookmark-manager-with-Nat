require 'pg'

class Bookmarks

  attr_reader :id, :title, :url

  def initialize(id:, title:, url:)
    @id = id
    @title = title
    @url = url
  end

  def self.all
    result = self.connection.exec("SELECT * FROM bookmarks;")
    result.map do |bookmark|
      Bookmarks.new(id: bookmark['id'], title: bookmark['title'], url: bookmark['url'])
    end
  end

  def self.create(url:, title:)
    result = self.connection.exec("INSERT INTO bookmarks (title, url) VALUES('#{title}', '#{url}') RETURNING id, title, url;")
    Bookmarks.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end

  def self.delete(bookmark)
    self.connection.exec("DELETE FROM bookmarks WHERE id = #{bookmark.id}")
  end
  
  def self.get_bookmark(id)
    bookmark = self.connection.exec("SELECT * FROM bookmarks WHERE id = #{id}").first
    url = bookmark['url']
    title = bookmark['title']
    Bookmarks.new(id: id, url: url, title: title)
  end

  private

  def self.connection
    if ENV['ENVIRONMENT'] == 'test'
      PG.connect(dbname: 'bookmark_manager_test')
    else
      PG.connect(dbname: 'bookmark_manager')
    end
  end

end
