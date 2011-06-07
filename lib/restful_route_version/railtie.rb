require "rails"

require "restful_route_version/dependency_ext"
require "restful_route_version/version_mapper"
require "restful_route_version/controller_path_ext"

module RestfulRouteVersion
  VERSION = '0.0.2'
  class Railtie < Rails::Railtie

    initializer "restful_route_version.configure_rails_initialization" do
      ActionDispatch::Routing::Mapper.send(:include, RestfulRouteVersion::VersionMapper)
      ActiveSupport::Dependencies.send(:include, RestfulRouteVersion::DependencyExt)
      ActiveSupport::Dependencies.extend(RestfulRouteVersion::DependencyExt)

      ActionController::Base.class_eval do
        def restful_route_version
          include RestfulRouteVersion::ControllerPathExt
        end
      end
    end
  end
end




