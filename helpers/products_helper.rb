module Helpers
  module ProductsHelper
    def underscore(name)
      name.downcase.gsub(' ', '_')
    end
  end
end
