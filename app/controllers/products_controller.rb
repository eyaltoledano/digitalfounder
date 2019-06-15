class ProductsController < ApplicationController

  # GET: /products

  get "/products" do
    @user = User.find(session[:user_id])
    @products = Product.all
    erb :"/products/index.html"
  end

  # GET: /products/new
  get "/products/new" do
    if logged_in?
      @user = User.find(session[:user_id])
      erb :"/products/new.html"
    else
      redirect '/login'
      flash[:notice] = "You need to be logged to create products."
    end
  end

  # POST: /products
  post "/products" do
    @user = User.find(session[:user_id])
    if params[:name] == "" || params[:description] == "" || params[:git_repo] == ""
      flash[:notice] = "You're missing some information. Let's try again."
      redirect '/signup'
    else
      @product = Product.create(:name => params[:name], :description => params[:description], :git_repo => params[:git_repo])
      @product.user = @user
      @product.status = "New"
      @product.save
      redirect "/products/#{@product.id}"
    end
  end

  # GET: /products/5
  get "/products/:id" do
    @product = Product.find(params[:id])
    @user = @product.user
    erb :"/products/show.html"
  end

  # GET: /products/5/edit
  get "/products/:id/edit" do
    erb :"/products/edit.html"
  end

  # PATCH: /products/5
  patch "/products/:id" do
    redirect "/products/:id"
  end

  # DELETE: /products/5/delete
  delete "/products/:id/delete" do
    redirect "/products"
  end
end
