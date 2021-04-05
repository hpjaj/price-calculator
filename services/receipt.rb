require_relative '../helpers/products_helper'

module Services
  class Receipt
    include Helpers::ProductsHelper

    COLUMN_1_WIDTH = 20
    COLUMN_2_WIDTH = 15

    attr_reader :total, :savings, :items

    def initialize(total:, savings:, items:)
      @total = total
      @savings = savings
      @items = items
    end

    def generate
      print_header
      print_line_items
      print_totals
    end

  private

    attr_reader :item, :name, :quantity, :price

    def print_header
      puts
      puts "#{headers[:item].ljust(COLUMN_1_WIDTH)} #{headers[:quantity].ljust(COLUMN_2_WIDTH)} #{headers[:price]}"
      puts separator
    end

    def headers
      { item: 'Item', quantity: 'Quantity', price: 'Price' }
    end

    def separator
      length = COLUMN_1_WIDTH + (COLUMN_2_WIDTH * 2)
      line   = ''

      length.times { line += '-' }
      line
    end

    def print_line_items
      items.each do |_uid, item|
        set_attributes_for(item)

        puts "#{name.ljust(COLUMN_1_WIDTH)} #{quantity.ljust(COLUMN_2_WIDTH)} #{price}"
      end
    end

    def set_attributes_for(item)
      set_item(item)
      set_name
      set_quantity
      set_price
    end

    def set_item(item)
      @item = item
    end

    def set_name
      @name = item[:product].name.capitalize
    end

    def set_quantity
      @quantity = item[:quantity].to_s
    end

    def set_price
      value  = item[:sales_price] || item[:regular_price]
      @price = integer_to_currency(value)
    end

    def print_totals
      puts
      puts "Total price: #{integer_to_currency(total)}"
      puts "You saved #{integer_to_currency(savings)} today." if savings > 0
    end
  end
end
