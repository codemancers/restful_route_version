module Api
  module V10
    class ArticlesController < ActionController::Base
      restful_route_version
      def index
        render :text => "Hello world from v10 ArticlesController"
      end
    end
  end
end
