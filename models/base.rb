module Models
  class Base
    def validate_integer!(*attributes)
      attributes.each do |attribute|
        raise ArgumentError, ":#{attribute} must be an Integer" unless send(attribute).is_a?(Integer)
      end
    end
  end
end
