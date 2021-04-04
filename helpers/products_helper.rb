module Helpers
  module ProductsHelper
    def underscore(name)
      name.downcase.gsub(' ', '_')
    end

    def humanize(uid)
      uid.to_s.gsub('_', ' ')
    end
  end
end
