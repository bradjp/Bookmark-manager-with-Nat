require 'bookmarks'
require 'database_helpers'

describe Bookmarks do

  subject(:bookmarks) { described_class.new }

  describe '#all' do
    it 'should return a list of bookmarks' do
      connection = PG.connect(dbname: 'bookmark_manager_test')

     bookmark = Bookmarks.create(url: 'www.bbc.co.uk/sport', title: 'BBC Sport')
      Bookmarks.create(url: 'www.miniclip.com', title: 'Miniclip')
      Bookmarks.create(url: 'www.cartoonnetwork.co.uk', title: 'CN')

      bookmarks = Bookmarks.all

      expect(bookmarks.length).to eq 3
      expect(bookmarks.first).to be_a Bookmarks
      expect(bookmarks.first.id).to eq bookmark.id
      expect(bookmarks.first.title).to eq 'BBC Sport'
      expect(bookmarks.first.url).to eq 'www.bbc.co.uk/sport'
    end
  end

  describe '#create' do
    it 'creates a new bookmark' do
      bookmark = Bookmarks.create(url: 'www.test.com', title: 'Test')
      persisted_data = persisted_data(id: bookmark.id)

      expect(bookmark).to be_a Bookmarks
      expect(bookmark.id).to eq persisted_data.first['id']
      expect(bookmark.title).to eq 'Test'
      expect(bookmark.url).to eq 'www.test.com'
   end
  end
end
