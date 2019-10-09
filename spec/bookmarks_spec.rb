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

  describe '#delete' do
    it 'deletes a bookmark' do
      bookmark = Bookmarks.create(url: 'www.test.com', title: 'Test')
      expect(Bookmarks.all).not_to be_empty
      Bookmarks.delete(bookmark)
      expect(Bookmarks.all).to be_empty
   end
    it 'deletes only the selected bookmark' do
      bookmark = Bookmarks.create(url: 'www.test1.com', title: 'Test1')
      bookmark2 = Bookmarks.create(url: 'www.test.com', title: 'Test')

      Bookmarks.delete(bookmark)
      expect(Bookmarks.all.length).to eq(1)
      expect(Bookmarks.all.first.title).to eq(bookmark2.title)
   end
  end

  describe '#get_bookmark' do
    context 'given an id' do
      it 'returns a bookmark' do
        bookmark = Bookmarks.create(url: 'www.test1.com', title: 'Test1')
        
        expect(Bookmarks.get_bookmark(bookmark.id)).to be_a(Bookmarks)
        expect(Bookmarks.get_bookmark(bookmark.id).url).to eq(bookmark.url)
        expect(Bookmarks.get_bookmark(bookmark.id).title).to eq(bookmark.title)
      end
    end
  end
  describe '#update' do
    context 'given an id, title and url' do
      it 'updates the given bookmark' do
        bookmark = Bookmarks.create(url: 'www.tst1.com', title: 'Tst1')
        
        Bookmarks.update(id: bookmark.id, url: 'www.test1.com', title: 'Test1')
        bookmark = Bookmarks.get_bookmark(bookmark.id)
        expect(bookmark.title).to eq 'Test1'
        expect(bookmark.url).to eq 'www.test1.com'
      end
    end
  end
end
