require_relative './grocery_list'
require_relative './compute'
require_relative './receipt'
require_relative '../helpers/products_helper'

module Services
  class CheckoutCart
    include Helpers::ProductsHelper

    attr_reader :products, :sales, :items, :error, :cart

    # @param products [Array] A collection of the store's current Product instances
    # @param sales [Array] A collection of the store's current Sale instances
    # @param items [String] A comma separated string of grocery list items
    #
    def initialize(products:, sales: [], items:)
      @products = products
      @sales = sales
      @items = items
    end

    def process_items
      add_items_to_cart!
      compute_totals
      success?
    rescue ArgumentError => e
      set_error(e)
    end

    def provide_receipt
      Services::Receipt.new(total: compute.total_price, savings: compute.total_savings, items: compute.items).generate
    end

  private

    attr_reader :compute

    def add_items_to_cart!
      @cart = Services::GroceryList.new(items: items, products: products).add_to_cart!
    end

    def compute_totals
      @compute = Services::Compute.new(products: products, sales: sales, cart: cart)

      compute.totals
    end

    def success?
      error.nil?
    end

    def set_error(e)
      @error = e.message

      success?
    end
  end
end
