require "rails"

require "restful_route_version_option_merger"
require "restful_route_version_dependencies"
require "restful_route_version_route_set"
require "restful_route_version_controller_path"

module RestfulRouteVersion
  VERSION = '0.0.1'
  class Railtie < Rails::Railtie

    initialize "restful_route_version.configure_rails_initialization" do
      ActionController::Routing::RouteSet::Mapper.send(:include, RestfulRouteVersion::RestfulRouteVersionRouteSet)
      ActiveSupport::Dependencies.send(:include, RestfulRouteVersion::RestfulRouteVersionDependencies)
      ActiveSupport::Dependencies.extend(RestfulRouteVersion::RestfulRouteVersionDependencies)

      ActionController::Base.class_eval do
        def restful_route_version
          include RestfulRouteVersion::RestfulRouteVersionControllerPath
        end
      end
    end
  end
end




