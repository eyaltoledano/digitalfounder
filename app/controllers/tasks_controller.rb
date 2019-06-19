class TasksController < ApplicationController

  # /product/version_number/tasks/task_id

  # GET: /tasks
  get "/tasks" do
    erb :"/tasks/index.html"
  end

  # GET: /tasks/new
  get "/products/:slug/versions/:version_number/new_task" do
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user

    if session[:user_id] == @product.user.id
      erb :"/tasks/new.html"
    else
      flash[:notice] = "Only the owner of #{@product.name} can create new tasks for #{@version.version_number}."
      redirect "/#{@product.slug}/#{@version.version_number}"
    end
  end

  # POST: /tasks
  post "/products/:slug/versions/:version_number/new_task" do
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user
    @version = Version.where(product_id: @product.id, version_number: params[:version_number]).first

    if params[:name] == "" || params[:description] == "" || params[:reward] == ""
      flash[:notice] = "The task you tried to submit is missing some information. Try again."
      redirect "/#{@product.slug}/#{@version.version_number}"
    else
      @task = Task.create(:name => params[:name], :description => params[:description], :reward => params[:reward])
      @task.version = @version
      @task.product = @product
      @task.status = "Open"
      @task.save
      @task.version.tasks << @task
      flash[:notice] = "The task was successfully created."

      redirect "/products/#{@product.slug}/versions/#{@version.version_number}"
    end
  end

  # GET: /tasks/5
  get "/products/:slug/versions/:version_number/tasks/:id" do
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user
    @version = Version.find_by_version_number(params[:version_number])
    @task = Task.find(params[:id])
    erb :"/tasks/show.html"
  end

  # GET: /tasks/5/edit
  get "/products/:slug/versions/:version_number/tasks/:id/edit" do
    @product = Product.find_by_slug(params[:slug])
    @user = @product.user
    @version = Version.find_by_version_number(params[:version_number])
    @task = Task.find(params[:id])

    erb :"/tasks/edit.html"
  end

  # PATCH: /tasks/5
  patch "/products/:slug/versions/:version_number/tasks/:id/update_status" do
    @task = Task.find(params[:id])

    if params[:status] == "Choose a new status"
      flash[:notice] = "You need to select a new status for #{@task.name}. Please try again."
      redirect "/dashboard"
    elsif params[:status] == "Ready for Review" && !params[:pr_link].include?("github.com")
      flash[:notice] = "Please make sure to submit your task with a valid Pull Request URL from GitHub. Your PR should be submitted to the project's repository."
      redirect "/dashboard"
    end

    if params[:status] == "Ready for Review"
      @task.status = "PR Submitted"
    else
      @task.status = params[:status]
    end


    @task.pr_link = params[:pr_link]

    if @task.save
      flash[:notice] = "The status for #{@task.name} was updated to #{@task.status}."

      @task_user = @task.user

      if @task.status == "Complete"
        @task_user.balance = @task_user.balance + @task.reward
        @task_user.save
      end
      redirect "/dashboard"
    else
      flash[:notice] = "Something went wrong trying to update the status for #{@task}. Please verify your submission and try again."
      redirect "/dashboard"
    end
  end

  patch "/products/:slug/versions/:version_number/tasks/:id/review_task" do
    @task = Task.find(params[:id])

    if params[:status] == "Choose a new status"
      flash[:notice] = "You need to select a new status for #{@task.name}. Please try again."
      redirect "/dashboard"
    end

    @task.status = params[:status]

    if @task.status == "Completed"
      rewardee = @task.user
      rewardee.balance += @task.reward.to_f
      rewardee.save
    end

    if @task.save
      flash[:notice] = "The status for #{@task.name} was updated to #{@task.status}."
      redirect "/dashboard"
    else
      flash[:notice] = "Something went wrong trying to update the status for #{@task}."
      redirect "/dashboard"
    end

  end

  patch '/products/:slug/versions/:version_number/tasks/:id/claim' do
    @task = Task.find(params[:id])
    current_user.claim(@task)
    redirect "/products/#{@task.product.slug}/versions/#{@task.version.version_number}"
  end

  # DELETE: /tasks/5/delete
  delete "/tasks/:id/delete" do
    @task = Task.find(params[:id])
    @task.destroy
    flash[:notice] = "#{task.name} was destroyed."
    redirect "/tasks"
  end
end
