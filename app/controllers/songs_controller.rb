require "rack-flash"

 class SongsController < ApplicationController
  enable :sessions
  use Rack::Flash

   get '/songs' do
    @songs = Song.all
    erb :'songs/index'
  end

   get '/songs/new' do
    erb :'/songs/new'
  end

   get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/show'
  end

   post '/songs' do
    @song = Song.create(name: params["Name"])
    if !params["Artist Name"].empty?
      if Artist.all.find{|artist| artist.name == params["Artist Name"]}
        @song.artist = Artist.all.find{|artist| artist.name == params["Artist Name"]}
        @song.genre_ids = params[:genres]
        @song.save
      else
        artist = Artist.create(name: params["Artist Name"])
        @song.artist = artist
        @song.genre_ids = params[:genres]
        @song.save
      end
    end
    flash[:message] = "Successfully created song."
    redirect to("/songs/#{@song.slug}")
  end

   get '/songs/:slug/edit' do
     @song = Song.find_by_slug(params[:slug])
     erb :'/songs/edit'
   end

   patch '/songs/:slug' do
     @song = Song.find_by_slug(params[:slug])
     @song.update(params[:song])
     @song.artist = Artist.find_or_create_by(:name => params["Artist Name"])
     @song.save
     flash[:message] = "Successfully updated song."
     redirect to("/songs/#{@song.slug}")
   end
end
