module RestfulRouteVersion

  module ControllerExt
    def restful_route_version
      view_paths.each do |path|
        append_view_path(InheritedViewResolver.new(path.to_s))
      end
    end
  end

  class InheritedViewResolver < ::ActionView::FileSystemResolver
    def find_templates(name, prefix, partial, details)
      klass = "#{prefix}_controller".camelize.constantize rescue nil

      return [] if !klass || !(klass < ActionController::Base)

      ancestor = klass.ancestors.second
      ancestor_prefix = ancestor.name.gsub(/Controller$/, '').underscore

      templates = super(name, ancestor_prefix, partial, details)
      return templates if templates.present?
      find_templates(name, ancestor_prefix, partial, details)
    end

  end
end
