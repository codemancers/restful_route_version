module Api
  module V10
    class ArticlesController
      restful_route_version
      def index
        render :text => "Hello world from v10 ArticlesController"
      end
    end
  end
end
