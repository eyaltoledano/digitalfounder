class VersionsController < ApplicationController

  # GET: /versions
  get "/versions" do
    erb :"/versions/index.html"
  end

  # GET: /versions/new
  get "/versions/new" do
    erb :"/versions/new.html"
  end

  # POST: /versions
  post "/versions" do
    # when a new version is created, assign its :version_number to "v1"
    redirect "/versions"
  end

  # GET: /versions/5
  get "/versions/:id" do
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
