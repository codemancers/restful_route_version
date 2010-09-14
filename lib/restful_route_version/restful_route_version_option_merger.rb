module RestfulRouteVersion
  class RestfulRouteVersionOptionMerger #:nodoc:
    instance_methods.each do |method|
      undef_method(method) if method !~ /^(__|instance_eval|class|object_id)/
    end

    def initialize(context, options)
      @context, @options = context, options
      @except_array = @options[:except].blank? ? [] : @options[:except].map(&:to_sym)
    end

    private
    def method_missing(method, * arguments, & block)
      if arguments.last.is_a?(Proc)
        proc = arguments.pop
        arguments << lambda { |* args| @options.deep_merge(proc.call(* args)) }
      else
        arguments << (arguments.last.respond_to?(:to_hash) ? deep_safe_merge(@options,arguments.pop) : @options.dup)
      end
      @context.__send__(method, * arguments, & block) unless @except_array.include?(arguments.first)
    end
  
    def deep_safe_merge(source_hash, new_hash)
      source_hash.merge(new_hash) do |key, old, new|
        old = old.to_hash if old.respond_to?(:to_hash)
        new = new.to_hash if new.respond_to?(:to_hash)

        if (old.kind_of?(Hash) and new.kind_of?(Hash))
          deep_merge(old, new)
        elsif (old.kind_of?(Array) and new.kind_of?(Array))
          old.concat(new).uniq
        else
          new
        end
      end
    end

  end
end
