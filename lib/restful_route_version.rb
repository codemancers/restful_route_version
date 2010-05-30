require "restful_route_version/restful_route_version_option_merger"
require "restful_route_version/restful_route_version_dependencies"
require "restful_route_version/restful_route_version_route_set"

ActionController::Routing::RouteSet::Mapper.send(:include, RestfulRouteVersion::RestfulRouteVersionRouteSet)






