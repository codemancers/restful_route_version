module Api
  module V11
    class ArticlesController
      def index
        render :text => "Hello world from v11 ArticlesController"
      end
    end
  end
end
