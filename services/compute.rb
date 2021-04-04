require_relative '../helpers/products_helper'

module Services
  class Compute
    include Helpers::ProductsHelper

    attr_reader :products, :sales, :cart, :items, :total_price, :total_savings

    # @param products [Array] A collection of the store's current Product instances
    # @param sales [Array] A collection of the store's current Sale instances
    # @param cart [Cart] An instance of Cart
    #
    def initialize(products:, sales: [], cart:)
      @products = products
      @sales = sales
      @cart = cart

      set_initial_values
    end

    def totals
      items.each do |product_uid, attributes|
        set_references_for(product_uid, attributes)
        compute_item_values
        update_total_price
        update_total_savings
      end
    end

  private

    attr_reader :uid, :quantity, :product, :sale, :values, :regular_price, :sales_price

    def set_initial_values
      @items         = cart.products
      @total_price   = 0
      @total_savings = 0
    end

    def set_references_for(product_uid, attributes)
      @uid      = product_uid.to_s
      @values   = attributes
      @quantity = attributes[:quantity]
      @product  = product_for_uid
      @sale     = sale_for_uid
    end

    def product_for_uid
      products.find { |product| product.uid == uid }
    end

    def sale_for_uid
      sales.find { |sale| sale.product_uid == uid }
    end

    def compute_item_values
      values.merge!(
        product: product,
        sale: sale,
        regular_price: set_regular_price,
        sales_price: set_sales_price,
        savings: savings
      )
    end

    def set_regular_price
      @regular_price = product.price * quantity
    end

    def set_sales_price
      reset_sales_price

      return if sale.nil?
      return if qualifying_sales_price == 0

      @sales_price = qualifying_sales_price + remaining_regular_price
    end

    def reset_sales_price
      @sales_price = nil
    end

    def qualifying_sales_price
      (quantity / sale.quantity) * sale.price
    end

    def remaining_regular_price
      (quantity % sale.quantity) * product.price
    end

    def savings
      return 0 if sales_price.nil?

      regular_price - sales_price
    end

    def update_total_price
      if sales_price
        @total_price += sales_price
      else
        @total_price += regular_price
      end
    end

    def update_total_savings
      @total_savings += savings
    end
  end
end
