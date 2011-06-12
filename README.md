# Restful Route Version #

### Useful for creating inheritable routes and controllers ###

Features
----------

* It extends routing API of rails by leting us inherit routes between versions:

    ```ruby
    version_namespace :api do
      version_namespace(:v10,:cache_route => true) do
        resources :articles
        resources :comments
        resources :notes
      end     
    
      version_namespace(:v11, :cache_route => true) do
        inherit_routes("/api/v10", :except => %w(articles))
        resources :articles
        resources :tags
      end
    
      version_namespace(:v12) do
        inherit_routes("/api/v11",:except => %w(notes))
        resources :lessons
      end
    end
    ```

   Important thing to remember is only routes which were cached via `cache_route => true` can be 
   reused for inheritance. Normal namespace blocks aren't cached.
   
* Dynamically defines controllers between versions. In other words if v11 inherits 'notes' route
   from v10, and v11 doesn't have its own NotesController defined the, plugin will
   automatically define `Api::V11::NotesController` which will inherit from `Api::V10::NotesController`. 
   

* Inherits view files (such as index.xml.builder) between versions. For example if `V11::ArticlesController`
   inherits `V10::ArticlesController` it will as well inherit all the view files of `v10/articles/`
   and hence there won't be any need to copy the view files around when creating new version of the API.

  
  Template inheritance will work out of box on Rails 3.1, but if you are still on 3.0.x series,
  you can use it now :

   ```ruby
   class Api::V10::BaseController < ActionController::Base
      restful_route_version
   end
   ```

* Works with Ruby 1.9.2 and Ruby 1.8.7

