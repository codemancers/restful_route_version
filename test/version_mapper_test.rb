require_relative "test_helper"

class VersionMapperTest < Test::Unit::TestCase
  context "Versioned routing extension" do
    setup do
      @route_set = ActionDispatch::Routing::RouteSet.new()
      @mapper = ActionDispatch::Routing::Mapper.new(@route_set)
    end

    should "provide version_namespace routing method" do
      assert @mapper.respond_to?(:version_namespace)
    end

    should "capture specified namespace when using version_namespace" do
      route_block = lambda do
        version_namespace("foo") do
          resources :articles
        end
      end
      @mapper.instance_exec(&route_block)
      assert !ActiveSupport::Dependencies.dynamically_defined_constants.blank?
    end

    should "capture route block if cache_route is true when using version_namespace" do
      route_block = lambda do
        version_namespace("foo", :cache_route => true) do
          resources :articles
        end
      end
      @mapper.instance_exec(&route_block)
      assert !@mapper.cached_namespace_blocks["/foo"].blank?
    end

    should "provide inherit_routes routing method" do
      assert @mapper.respond_to?(:inherit_routes)
    end
  end

  context "Restful route extension with inherit_routes" do
    setup do
      @route_set = ActionDispatch::Routing::RouteSet.new()
      @mapper = ActionDispatch::Routing::Mapper.new(@route_set)

      @route_block = lambda do
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
          end #end of map.version_namespace(:api)
      end #end of route_block

    end #end of setup block

    should "create derived routes when using inherit_routes" do
      @mapper.instance_exec(&@route_block)
      v12_tag_route = @route_set.named_routes.routes[:edit_api_v12_tag]
      assert !v12_tag_route.blank?
      assert_match /\/api\/v12\/tags\/\:id\/edit/, v12_tag_route.to_s
    end
    
    should "not create routes for except resources" do
      @mapper.instance_exec(&@route_block)
      article_route = @route_set.named_routes.routes[:new_api_v12_article]
      assert !article_route.blank?

      note_route = @route_set.named_routes.routes[:new_api_v12_note]
      assert note_route.blank?
    end
  end

  context "Restful route extension with inherit_routes and creating controllers dynamically" do
    setup do 
      @route_set = ActionDispatch::Routing::RouteSet.new()
      @mapper = ActionDispatch::Routing::Mapper.new(@route_set)

      @route_block = lambda do
        version_namespace :api do
          version_namespace(:v10,:cache_route => true) do
            resources :articles
            resources :notes
          end
  
          version_namespace(:v11, :cache_route => true) do
            inherit_routes("/api/v10", :except => %w(articles))
            resources :tags
            resources :articles
          end

          version_namespace(:v12) do
            inherit_routes("/api/v11")
            resources :lessons
          end
  
        end #end of map.version_namespace(:api)
      end #end of route_block
    end #end of setup block

    should "automatically load classes which has to be loaded dynamically" do
      @mapper.instance_exec(&@route_block)
      assert defined?(Api::V11::NotesController)
      t_superclass = Api::V11::NotesController.superclass.to_s
      assert_equal "Api::V10::NotesController", t_superclass

      assert defined?(Api::V12::NotesController)
      assert_equal "Api::V11::NotesController", Api::V12::NotesController.superclass.to_s
    end
  end #end of context inherit_routes


  context "Inherit controller with except" do 
    setup do 
      @route_set = ActionDispatch::Routing::RouteSet.new()
      @mapper = ActionDispatch::Routing::Mapper.new(@route_set)

      @route_block = lambda do
        version_namespace :api do
          version_namespace(:v10,:cache_route => true) do
            resources :articles
            resources :notes
          end
  
          version_namespace(:v11, :cache_route => true) do
            inherit_routes("api/v10", :except => %w(articles))
            resources :tags
            resources :articles
          end

          version_namespace(:v12) do
            inherit_routes("api/v11", :except => %w(tags))
            resources :lessons
          end
  
        end #end of map.version_namespace(:api)
      end #end of route_block
    end #end of setup block

    should "not create controllers in only specified namespace" do
      @mapper.instance_exec(&@route_block)
      ActiveSupport::Dependencies.remove_constant("Api::V12::TagsController")

      assert defined?(Api::V11::ArticlesController)
      assert defined?(Api::V12::ArticlesController)
      assert (Api::V12::ArticlesController < Api::V11::ArticlesController)
      assert (Api::V12::NotesController < Api::V11::NotesController)
      assert (Api::V11::NotesController < Api::V10::NotesController)
      assert !defined?(Api::V12::TagsController)
    end
  end

  context "Inherit controller with except for non-existant" do 
    setup do
      ActiveSupport::Dependencies.remove_constant("Api::V11::QuestionsController")
      ActiveSupport::Dependencies.remove_constant("Api::V12::QuestionsController")
      @route_set = ActionDispatch::Routing::RouteSet.new()
      @mapper = ActionDispatch::Routing::Mapper.new(@route_set)      

      @route_block = lambda do
        version_namespace :api do
          version_namespace(:v10,:cache_route => true) do
            resources :articles
            resources :notes
            resources :questions
          end
          
          version_namespace(:v11, :cache_route => true) do
            inherit_routes("api/v10", :except => %w(articles questions))
            resources :tags
            resources :articles
          end

          version_namespace(:v12) do
            inherit_routes("api/v11")
            resources :lessons
          end
        end #end of map.version_namespace(:api)
      end #end of route_block

    end #end of setup block

    should "not create controllers in only specified namespace" do
      @mapper.instance_exec(&@route_block)
      assert defined?(Api::V10::QuestionsController)
      assert !defined?(Api::V11::QuestionsController)
      assert !defined?(Api::V12::QuestionsController)
    end
  end
  
end
