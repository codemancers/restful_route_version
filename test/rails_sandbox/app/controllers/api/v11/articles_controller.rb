module Api
  module V11
    class ArticlesController < Api::V10::ArticlesController
      def index
        render :text => "Hello world from v11 ArticlesController"
      end
    end
  end
end
