module RestfulRouteVersion
  module DependencyExt
    mattr_accessor :dynamically_defined_constants
    self.dynamically_defined_constants = Set.new()

    def remove_unloadable_constants!
      autoloaded_constants.each { |const|
        remove_constant const unless dynamically_defined_constants.include?(const)
      }
      autoloaded_constants.clear
      ActiveSupport::Dependencies::Reference.clear!
      explicitly_unloadable_constants.each { |const| remove_constant const }
    end
  end
end
