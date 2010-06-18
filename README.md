# Restful Route Version plugin #

Features
----------

1. Lets you inherit routes between versions

        map.version_namespace :api do |api_routes|
            api_routes.version_namespace(:v10,:cache_route => true) do |v10_routes|
                v10_routes.resources :articles
                v10_routes.resources :comments
                v10_routes.resources :notes
            end
            api_routes.version_namespace(:v11, :cache_route => true) do |v11_routes|
                v11_routes.inherit_routes("api/v10", :except => %w(articles))
                v11_routes.resources :tags
                v11_routes.resources :articles, :collection => {:search => :get }
            end
            api_routes.version_namespace(:v12) do |v12_routes|
                v12_routes.inherit_routes("api/v11")
                v12_routes.resources :lessons
            end
        end

2. Dynamically defines controllers between versions. So if v11 inherits 'notes' route
   from v10, and v11 doesn't have its own NotesController defined the, plugin will
   automatically define Api::V11::NotesController which will inherit from Api::V10::NotesController.


3. Inherits view files (such as index.xml.builder) between versions. For example if `V11::ArticlesController`
   inherits `V10::ArticlesController` it will as well inherit all the view files of `v10/articles/`
   and hence there won't be any need to copy the view files around when creating new version of the API.

   However view file inheritance doesn't work out of the box and you will have to explicitly enable it. Currently
   assuming you have some sort of base controller for your controllers which needs to be versioned, you will need
   to add:

        class Api::V10::BaseController < ActionController::Base
            restful_route_version
        end

   You can add `restful_route_version` to ApplicationController as well, but since the plugin replaces template
   finding logic of rails, it may not be useful for entire set of controllers.


4. Code is generally pretty test well covered.

Warning
----------

Might be still rough around the edges
  

   

