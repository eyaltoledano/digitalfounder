class VersionsController < ApplicationController

  # GET: /versions
  get "/versions" do
    erb :"/versions/index.html"
  end

  # GET: /versions/new
  get "/:slug/new_version" do
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user

    if session[:user_id] == @product.user.id
      erb :"/versions/new.html"
    else
      flash[:notice] = "Only the owner of #{@product.name} can create new versions."
      redirect "/#{@product.slug}"
    end
  end

  # POST: /version-s
  post "/:slug/new_version" do
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user
    # when a new version is created, add the current user to version.users
    # when a new version is created, set its progress to 0

    if params[:description] == "" || params[:release_date] == "" || params[:version_number] == ""
      flash[:notice] = "Looks like something's not quite right with what you submitted. Try again."
      redirect "/#{@product}/new_version"
    else
      @version = Version.create(description: params[:description], release_date: params[:release_date], version_number: params[:version_number])
      @version.product = @product
      @version.user = @user
      @version.version_number = "v#{@product.versions.count}"
      @version.progress = "0"
      @version.save
      flash[:notice] = "#{@product.name} #{@version.version_number} was successfully created!"
      redirect "/#{@product.slug}/versions/#{@version.version_number}"
    end
  end

  # GET: /versions/5
  get "/:slug/versions/:version_number" do
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user
    @version = @product.versions.find_by_version_number(params[:version_number])
    erb :"/versions/show.html"
  end

  # GET: /versions/5/edit
  get "/versions/:id/edit" do
    erb :"/versions/edit.html"
  end

  # PATCH: /versions/5
  patch "/versions/:id" do
    redirect "/versions/:id"
  end

  # DELETE: /versions/5/delete
  delete "/versions/:id/delete" do
    redirect "/versions"
  end
end
