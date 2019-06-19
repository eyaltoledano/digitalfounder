class ProductsController < ApplicationController

  # GET: /products

  get "/products" do
    @user = User.find(session[:user_id]) if logged_in?
    @products = Product.all
    erb :"/products/index.html"
  end

  # GET: /products/new
  get "/new_product" do
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
      params[:name].chomp
      @product = Product.create(:name => params[:name], :description => params[:description], :git_repo => params[:git_repo])
      @product.user = @user
      @product.status = "New"
      @product.save
      redirect "/products/#{@product.slug}"
    end
  end

  # GET: /products/5
  get "/products/:slug" do
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user
    @versions = @product.versions
    erb :"/products/show.html"
  end

  # GET: /products/5/edit
  get "/products/:slug/edit" do
    redirect '/login' && flash[:notice] = "You need to be logged in to edit products." if !logged_in?
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user

    if @user != current_user
      flash[:notice] = "Can't edit someone else's product. Play nice!"
      redirect '/dashboard'
    else
      @products = @user.products
      erb :"/products/edit.html"
    end
  end

  # PATCH: /products/5
  patch "/products/:id" do
    @product = Product.find(params[:id])
    @user = @product.user
    if params[:name].empty? || params[:description].empty? || params[:git_repo].empty?
       flash[:notice] = "Can't leave any fields empty. Mind filling those in?"
      redirect "/products/#{@product.slug}/edit"
    else
      if @product.update(name: params[:name], description: params[:description], git_repo: params[:git_repo])
        flash[:notice] = "#{@product.name}'s profile was successfully edited."
        redirect "/products/#{@product.slug}/edit"
      else
        flash[:notice] = "Something went wrong. Try again?"
        redirect "/products/#{@product.slug}/edit"
      end
    end

    redirect "/products/#{@product.slug}/edit"
  end

  # DELETE: /products/5/delete
  delete "/products/:slug/delete" do
    redirect '/login' && flash[:notice] = "You need to be logged in to delete a product." if !logged_in?

    @product = Product.find_by_slug(params[:slug])
    if @product.user != current_user
      flash[:notice] = "Can't delete someone else's product. Play nice!"
      redirect '/dashboard'
    else
      @product = Product.find_by_slug(params[:slug])
      product_name = @product.name
      @product.destroy
      flash[:notice] = "It's done. #{product_name} was destroyed."
      redirect "/settings"
    end
  end
end
