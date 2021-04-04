require_relative './base'

module Models
  class Sale < Models::Base
    attr_reader :product_uid, :quantity, :price

    def initialize(product_uid:, quantity:, price:)
      @product_uid = product_uid
      @quantity = quantity
      @price = price

      validate_integer!(:price, :quantity)
    end
  end
end
