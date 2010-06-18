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

4. Code is generally pretty well covered.

Waring
----------

Might be still rough around the edges
  

   

