module RestfulRouteVersion
  module DependencyExt
    def self.included(base)
      base.send(:remove_method, :remove_unloadable_constants!)
    end
    
    mattr_accessor :dynamically_defined_constants
    self.dynamically_defined_constants = Set.new()

    # FIXME: make this more graceful without removing existing method
    def remove_unloadable_constants!
      autoloaded_constants.each { |const|
        remove_constant const unless dynamically_defined_constants.include?(const)
      }
      autoloaded_constants.clear
      explicitly_unloadable_constants.each { |const| remove_constant const }
    end
  end
end
