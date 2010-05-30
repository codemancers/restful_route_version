module RestfulRouteVersion
  module RestfulRouteVersionRouteSet
    attr_accessor :cached_namespace_blocks
    def version_namespace(name, options = {}, &block)
      new_options =
        if options[:namespace]
          {:path_prefix => "#{options.delete(:path_prefix)}/#{name}", :name_prefix => "#{options.delete(:name_prefix)}#{name}_", :namespace => "#{options.delete(:namespace)}#{name}/"}.merge(options)
        else
          {:path_prefix => name, :name_prefix => "#{name}_", :namespace => "#{name}/"}.merge(options)
        end
      @cached_namespace_blocks ||= {}
      create_controller_class(new_options[:path_prefix].to_s.camelize,Module.new)
      @cached_namespace_blocks[new_options[:path_prefix]] = block if options[:cache_route]
      with_options(new_options, &block)
    end

    def inherit_routes(* entities)
      options = entities.extract_options!
      options[:old_namespace] ||= entities.first
      entities.each { |entity|
        inherited_route_block = @cached_namespace_blocks[entity]
        with_versioned_options(options, &inherited_route_block)
      }
      create_derived_controllers(options[:old_namespace], options)
    end

    def create_derived_controllers(old_namespace, options = {})
      Dir["#{Rails.root}/app/controllers/#{old_namespace}/*.rb"].each do |controller_file_name|
        require_or_load(controller_file_name)
      end
      exclude_constants = options[:except].blank? ? [] : options[:except]
      current_namespace = options[:namespace]
      controllers_to_exclude = exclude_constants.map { |x| (old_namespace + "/#{x}Controller").camelize }
      old_namespace.camelize.constantize.constants.each do |constant_name|
        full_constant_name = old_namespace.camelize + "::" + constant_name
        new_controller_name = "#{current_namespace.camelize}#{constant_name}"
        if create_controller_dynamically?(controllers_to_exclude, full_constant_name, new_controller_name)
          create_controller_class(new_controller_name,Class.new(full_constant_name.constantize))
        end
      end
    end

    def create_controller_dynamically?(controllers_to_exclude, old_controller_name, new_controller_name)
      !controllers_to_exclude.include?(old_controller_name) &&
        old_controller_name =~ /Controller$/ &&
        !File.exists?("#{Rails.root}/app/controllers/#{new_controller_name.underscore}.rb")
    end


    def create_controller_class(full_constant_name, klass_constant)
      names = full_constant_name.split('::')
      ActiveSupport::Dependencies.dynamically_defined_constants << full_constant_name
      names.shift if names.empty? || names.first.empty?
      constant = Object
      names.each do |name|
        if constant.const_defined?(name)
          constant = constant.const_get(name)
        else
          constant = constant.const_set(name, klass_constant)
        end
      end
    end

    def with_versioned_options(options = {})
      yield RestfulRouteVersionOptionMerger.new(self, options)
    end
  end
end
