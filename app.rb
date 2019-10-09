require 'sinatra/base'
require_relative './lib/bookmarks'

class BookmarkManager < Sinatra::Base
  enable :method_override

  get '/' do
    "Bookmark Manager"
    # erb :index
  end

  get '/bookmarks' do
    @bookmarks = Bookmarks.all
    puts @bookmarks.first.url
    erb(:bookmarks)
  end

  get '/bookmarks/new' do

    erb(:"bookmarks/new")
  end

  post '/bookmarks' do
    Bookmarks.create(url: params[:url], title: params[:title])
    redirect '/bookmarks'
  end

  delete '/bookmarks/delete/:id' do
    bookmark = Bookmarks.get_bookmark(params[:id].to_i)
    Bookmarks.delete(bookmark)
    redirect '/bookmarks'
  end

  get '/bookmarks/:id/edit' do
    @bookmark_id = params[:id]
    erb :'bookmarks/edit' 
  end

  patch '/bookmarks/:id' do
    id, title, url = params[:id], params[:title], params[:url]
    Bookmarks.update(id: id, title: title, url: url)

    redirect '/bookmarks'
  end


  run! if app_file == $0
end
