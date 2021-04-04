module Helpers
  module ProductsHelper
    def underscore(name)
      name.downcase.gsub(' ', '_')
    end

    def integer_to_currency(number)
      currency = sprintf("%.2f", (number / 100.0))

      "$#{currency}"
    end

    def humanize(uid)
      uid.to_s.gsub('_', ' ')
    end
  end
end
