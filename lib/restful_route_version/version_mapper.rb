module RestfulRouteVersion
  module VersionMapper
    attr_accessor :cached_namespace_blocks
    def version_namespace(path, options = {}, &block)
      path = path.to_s
      options = { :path => path, :as => path, :module => path,
                  :shallow_path => path, :shallow_prefix => path }.merge!(options)
      
      @cached_namespace_blocks ||= {}
      

      scope(options) { 
        create_controller_class(@scope[:module].to_s.camelize,Module.new)
        @cached_namespace_blocks[@scope[:path]] = block if options[:cache_route]
        block.call 
      }
    end

    def resources(*resources, &block)
      except_options = @scope[:options].blank? ? [] : @scope[:options][:except]
      return if skip_resource?(resources,except_options)
      super(*resources, &block)
    end

    def resource(*resources, &block)
      except_options = @scope[:options].blank? ? [] : @scope[:options][:except]
      return if skip_resource?(resources,except_options)
      super(*resources, &block)
    end

    def skip_resource?(resources, except_options)
      return false if(resources.length > 1 || except_options.blank?)
      return true if except_options.include?(resources.first.to_s)
      false
    end

    def inherit_routes(*entities)
      options = entities.extract_options!
      new_options = merge_except_options(options)
      new_options[:old_namespace] = @scope[:options][:old_namespace] || entities.dup.shift


      entities.each { |entity|
        inherited_route_block = @cached_namespace_blocks[entity]
        inherited_route_block && scope(new_options) do
          inherited_route_block.call()
        end
      }
      create_derived_controllers(new_options[:old_namespace], new_options)
    end

    def merge_except_options(options)
      options[:except] ||= []
      options[:namespace] = @scope[:path]
      if old_exception_option = @scope[:options][:except]
        options[:except] += old_exception_option
      end
      options
    end

    def create_derived_controllers(old_namespace, options = {})
      old_namespace.gsub!(/^\/?/,'')
      current_namespace = options[:namespace].gsub(/^\/?/,'')
      Dir["#{Rails.root}/app/controllers/#{old_namespace}/*.rb"].each do |controller_file_name|
        require_or_load(controller_file_name)
      end

      exclude_constants = options[:except].blank? ? [] : options[:except]

      controllers_to_exclude = exclude_constants.map { |x| (old_namespace + "/#{x}Controller").camelize }
      old_namespace.camelize.constantize.constants.each do |constant_name|
        full_constant_name = old_namespace.camelize + "::" + constant_name.to_s
        new_controller_name = "#{current_namespace.camelize}::#{constant_name}"
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
  end
end
