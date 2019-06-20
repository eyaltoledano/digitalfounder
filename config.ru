require './config/environment'

require 'active_support/all'

require 'rubygems'
require 'sinatra'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride

run ApplicationController
use TasksController
use VersionsController
use ProductsController
use UsersController
