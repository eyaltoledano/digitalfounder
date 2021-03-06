
class VersionsController < ApplicationController

  # GET: /versions
  get "/products/:slug/versions" do
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user
    erb :"/versions/index.html"
  end

  # GET: /versions/new
  get "/products/:slug/new_version" do
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user

    if session[:user_id] == @product.user.id
      erb :"/versions/new.html"
    else
      flash[:notice] = "Only the owner of #{@product.name} can create new versions."
      redirect "/products/#{@product.slug}"
    end
  end

  # POST: /version-s
  post "/products/:slug/new_version" do
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user
    if params[:description] == "" || params[:release_date] == "" || params[:version_number] == ""
      flash[:notice] = "Looks like something's not quite right with what you submitted. Try again."
      redirect "/products/#{@product}/new_version"
    else
      @version = Version.create(description: params[:description], release_date: params[:release_date], version_number: params[:version_number])
      @version.product = @product
      @version.user = @user
      @version.version_number = "v#{@product.versions.count + 1}"
      @version.progress = "0"
      @version.save
      flash[:notice] = "#{@product.name} #{@version.version_number} was successfully created!"
      redirect "/products/#{@product.slug}/versions/#{@version.version_number}"
    end
  end

  # GET: /versions/5
  get "/products/:slug/versions/:version_number" do
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user
    @version = @product.versions.find_by_version_number(params[:version_number])

    if !@version
      @open_tasks = "0"
      @available_rewards = "0"
      @num_of_contributors = []
    else
      @open_tasks = @version.open_tasks.count

      if !@version.tasks.empty?
        rewards = []
        @version.tasks.where(status: "Open").each do |task|
          rewards << task.reward.to_f
        end
        @available_rewards = rewards.inject(0){|sum,x| sum + x }
      else
        @available_rewards = "0"
      end

      @num_of_contributors = @version.tasks_with_contributors
    end
    # binding.pry
    erb :"/versions/show.html"
  end

  # GET: /versions/5/edit
  get "products/:slug/versions/:id/edit" do
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user
    @version = Version.find(params[:id])
    erb :"/versions/edit.html"
  end

  # PATCH: /versions/5
  patch "products/:slug/versions/:id" do
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user
    @version = Version.find(params[:id])
    redirect "/versions/:id"
  end

  # DELETE: /versions/5/delete
  delete "products/:slug/versions/:id/delete" do
    @version = Version.find(params[:id])
    @version.destroy
    redirect "/versions"
  end
end
