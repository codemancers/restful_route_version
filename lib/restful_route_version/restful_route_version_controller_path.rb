module RestfulRouteVersion
  module RestfulRouteVersionControllerPath
    
    def default_template(action_name = self.action_name)
      @@cached_template_paths ||= {}
      template_cache_key = "#{default_template_name(action_name)}.#{default_template_format}"
      template_from_cache = find_from_template_cache(template_cache_key)
      return template_from_cache if template_from_cache
      
      base_klass = self.class
      begin
        t = self.view_paths.find_template(find_base_klass_template(base_klass,action_name), default_template_format)
        @@cached_template_paths[template_cache_key] = t
        t
      rescue ActionView::MissingTemplate => template_error
        base_klass = base_klass.superclass
        raise template_error unless base_klass < ::ActionController::Base
        retry
      end
    end

    

    def find_from_template_cache(template_cache_key)
      ActionView::Base.cache_template_loading && @@cached_template_paths[template_cache_key]
    end

    def find_base_klass_template(base_klass,action_name = self.action_name)
      if action_name
        action_name = action_name.to_s
        if action_name.include?('/') && template_path_includes_controller?(action_name)
          action_name = strip_out_controller(action_name)
        end
      end
      "#{base_klass.controller_path}/#{action_name}"
    end
  end
end

module ActionView
  class Base
    def _pick_partial_template(partial_path)
      base_klass = self.controller.class
      begin
        t = _pick_klass_partial_template(partial_path,base_klass)
        t
      rescue ActionView::MissingTemplate => template_error
        base_klass = base_klass.superclass
        raise template_error unless base_klass < ::ActionController::Base
        retry
      end
    end

    def _pick_klass_partial_template(partial_path,base_klass)
      if partial_path.include?('/')
        path = File.join(File.dirname(partial_path), "_#{File.basename(partial_path)}")
      elsif controller
        path = "#{base_klass.controller_path}/_#{partial_path}"
      else
        path = "_#{partial_path}"
      end
      
      self.view_paths.find_template(path, self.template_format)
    end

  end
end
