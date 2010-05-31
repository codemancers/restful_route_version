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


Known Issues
----------
1. If `Api::V10::NotesController` uses view files such as `index.xml.erb`, the meta-programmatically defined
  derived controller `Api::V11::NotesController` will try to find view files under `app/views/api/v11/notes`
  rather than `app/views/api/v10/notes`.

  

   

