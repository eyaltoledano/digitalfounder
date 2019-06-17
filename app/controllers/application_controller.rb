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

  def current_url
    "http://#{request.host}:#{request.port}#{request.path}"
  end

  def requested_product_id
    request.path.split("/").last
  end

  get "/" do
    if logged_in?
      redirect '/dashboard'
    else
      erb :index
    end
  end


end

# This below method helps create a percentage of a number
# Usage: 1.percent_of(10) #=> 10.0

class Numeric
  def percent_of(n)
    self.to_f / n.to_f * 100.0
  end
end
