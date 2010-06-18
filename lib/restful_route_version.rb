require "restful_route_version/restful_route_version_option_merger"
require "restful_route_version/restful_route_version_dependencies"
require "restful_route_version/restful_route_version_route_set"
require "restful_route_version/restful_route_version_controller_path"

ActiveSupport::Dependencies.extend(RestfulRouteVersion::RestfulRouteVersionDependencies)
ActiveSupport::Dependencies.send(:include, RestfulRouteVersion::RestfulRouteVersionDependencies)
ActionController::Routing::RouteSet::Mapper.send(:include, RestfulRouteVersion::RestfulRouteVersionRouteSet)

module RestfulRouteVersion
  module ActionControllerExtension
    unloadable
    def restful_route_version
      include RestfulRouteVersion::RestfulRouteVersionControllerPath
    end
  end
end




