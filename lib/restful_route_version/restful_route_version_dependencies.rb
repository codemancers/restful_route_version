module RestfulRouteVersion
  module RestfulRouteVersionDependencies
    def self.included(base)
      base.send(:remove_method, :remove_unloadable_constants!)
    end
    #alias_method :old_remove_unloadable_constants!, :remove_unloadable_constants!
    
    mattr_accessor :dynamically_defined_constants
    @@dynamically_defined_constants = Set.new()

    def remove_unloadable_constants!
      autoloaded_constants.each { |const|
        remove_constant const unless dynamically_defined_constants.include?(const)
      }
      autoloaded_constants.clear
      explicitly_unloadable_constants.each { |const| remove_constant const }
    end
  end
end
