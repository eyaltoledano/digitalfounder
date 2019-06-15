class UsersController < ApplicationController

  # GET: /users
  get "/users" do
    erb :"/users/index.html"
  end

  # GET: /users/new
  get "/signup" do
    erb :"/users/new.html"
  end

  post "/signup" do
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      flash[:notice] = "Looks like something's not quite right with what you submitted. Try again."
      redirect '/signup'
    else
      @user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
      session[:user_id] = @user.id
      redirect '/dashboard'
    end
  end

  get "/dashboard" do
    if logged_in?
      @user = User.find(session[:user_id])
      time = Time.now.hour
      if time > 10 && time < 12 || time == 0
        @greeting = "Good morning"
      elsif time > 12 && time < 18
        @greeting = "Good afternoon"
      elsif time > 18 && time < 24
        @greeting = "Good evening"
      end
      @owned_products = @user.products.count
    else
      redirect '/login'
      flash[:notice] = "You need to be logged in to access this page."
    end
    erb :"/users/dashboard.html"
  end

  get '/login' do
    if !logged_in?
      erb :"/users/login.html"
    else
      flash[:notice] = "You're already logged in."
      redirect '/dashboard'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if !user
      flash[:notice] = "Doesn't look like that username or password is correct."
      redirect "/login"
    end

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/dashboard"
    else
      flash[:notice] = "Something went wrong. Try again?"
      redirect to '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect "/"
  end

  # POST: /users
  post "/users" do
    redirect "/users"
  end

  # GET: /users/5
  get "/users/:id" do
    erb :"/users/show.html"
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    erb :"/users/edit.html"
  end

  # PATCH: /users/5
  patch "/users/:id" do
    redirect "/users/:id"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end
end
