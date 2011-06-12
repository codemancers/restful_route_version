module Api
  module V10
    class QuestionsController < ActionController::Base
      restful_route_version
      def index
        render :text => "Hello world from v10 QuestionsController"
      end
    end
  end
end
