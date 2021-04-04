require_relative '../models/cart'
require_relative '../helpers/products_helper'

module Services
  class GroceryList
    include Helpers::ProductsHelper

    ALPHANUMERIC_COMMA_REGEX = /[^a-z0-9,]/i

    attr_reader :items, :products

    # @param items [String] A comma separated string of grocery list items
    # @param products [Array] A collection of the store's current Product instances
    #
    def initialize(items:, products:)
      @items = items
      @products = products
    end

    # @return [Cart] An instance of Cart
    #
    def add_to_cart!
      sanitize
      compact
      item_present!
      map_to_product_uids!
      items_are_sellable!
      build_cart
    end

  private

    attr_reader :uids

    def sanitize
      items.gsub!(ALPHANUMERIC_COMMA_REGEX, '')
    end

    def compact
      @items = items
        .split(',')
        .map { |item| item.empty? ? nil : item }
        .compact
    end

    def item_present!
      raise ArgumentError, "You must supply at least one grocery list item" if items.size == 0
    end

    def map_to_product_uids!
      @uids = items.map { |item| underscore(item) }
    end

    def items_are_sellable!
      uids.each do |uid|
        raise ArgumentError, "Apologies, but we do not sell '#{humanize(uid)}'. Please try again." unless we_sell?(uid)
      end
    end

    def we_sell?(uid)
      product_uids.include?(uid.to_s)
    end

    def product_uids
      @product_uids ||= products.map(&:uid)
    end

    def build_cart
      Models::Cart.new(product_uids: uids)
    end
  end
end
