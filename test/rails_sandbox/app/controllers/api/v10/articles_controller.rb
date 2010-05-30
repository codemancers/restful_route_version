module Api
  module V10
    class ArticlesController
      def index
        render :text => "Hello world from v10 ArticlesController"
      end
    end
  end
end
