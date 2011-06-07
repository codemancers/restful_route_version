require "rails"

require "restful_route_version_option_merger"
require "restful_route_version_dependencies"
require "version_mapper"
require "restful_route_version_controller_path"

module RestfulRouteVersion
  VERSION = '0.0.1'
  class Railtie < Rails::Railtie

    initialize "restful_route_version.configure_rails_initialization" do
      ActionDispatch::Routing::Mapper.send(:include, RestfulRouteVersion::VersionMapper)
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




