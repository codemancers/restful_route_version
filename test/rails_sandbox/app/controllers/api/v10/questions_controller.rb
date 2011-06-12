module Api
  module V10
    class QuestionsController
      restful_route_version
      def index
        render :text => "Hello world from v10 QuestionsController"
      end
    end
  end
end
