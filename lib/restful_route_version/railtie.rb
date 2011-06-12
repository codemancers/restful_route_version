require "rails"

require "restful_route_version/dependency_ext"
require "restful_route_version/version_mapper"
require "restful_route_version/inherited_view_resolver"

module RestfulRouteVersion
  VERSION = '0.0.2'
  class Railtie < Rails::Railtie

    initializer "restful_route_version.configure_rails_initialization" do
      ActionDispatch::Routing::Mapper.send(:include, RestfulRouteVersion::VersionMapper)
      ActiveSupport::Dependencies.send(:include, RestfulRouteVersion::DependencyExt)
      ActiveSupport::Dependencies.extend(RestfulRouteVersion::DependencyExt)
      ActionController::Base.extend(ControllerExt)
    end
  end
end




