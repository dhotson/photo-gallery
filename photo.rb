require 'sinatra'

get '/' do
  erb :index, :locals => {
    :photos => Dir.glob("public/photos/800-*.JPG").map { |f| f.gsub(/^public\//, '') }
  }
end

get '/photo.css' do
  scss :photo
end

get '/photo.js' do
  coffee :photo
end
