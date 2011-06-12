class Api::V10::NotesController < ActionController::Base
  restful_route_version
  def index
    render :text => "Hello from V10 notes controller, lolz"
  end
end
