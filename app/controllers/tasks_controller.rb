class TasksController < ApplicationController

  # /product/version_number/tasks/task_id

  # GET: /tasks
  get "/tasks" do
    erb :"/tasks/index.html"
  end

  # GET: /tasks/new
  get "/:slug/versions/:version_number/new_task" do
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user
    @version_number = Version.find_by_version_number(params[:version_number])

    if session[:user_id] == @product.user.id
      erb :"/tasks/new.html"
    else
      flash[:notice] = "Only the owner of #{@product.name} can create new tasks for #{@version.version_number}."
      redirect "/#{@product.slug}/#{@version.version_number}"
    end
  end

  # POST: /tasks
  post "/:slug/:version_number/new_task" do
    redirect "/tasks"
  end

  # GET: /tasks/5
  get "/:slug/:version_number/tasks/:id" do
    erb :"/tasks/show.html"
  end

  # GET: /tasks/5/edit
  get "/:slug/:version_number/tasks/:id/edit" do
    erb :"/tasks/edit.html"
  end

  # PATCH: /tasks/5
  patch "/:slug/:version_number/tasks/:id" do
    redirect "/tasks/:id"
  end

  # DELETE: /tasks/5/delete
  delete "/:slug/:version_number/tasks/:id/delete" do
    redirect "/tasks"
  end
end
