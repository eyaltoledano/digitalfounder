require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "d333ff-d1g1t4lf0und3r"
  end

  def logged_in?
    true if !session[:user_id].nil?
  end

  def current_user
    User.find(session[:user_id])
  end

  get "/" do
    erb :index
  end


end
