require_relative './base'
require_relative '../helpers/products_helper'

module Models
  class Product < Models::Base
    include Helpers::ProductsHelper

    attr_reader :name, :price, :uid

    def initialize(name:, price:)
      @name = name
      @price = price
      @uid = set_uid

      validate_integer!(:price)
    end

  private

    def set_uid
      underscore(name)
    end
  end
end
