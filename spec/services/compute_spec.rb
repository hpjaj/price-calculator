require 'spec_helper'

RSpec.describe Services::Compute do
  let(:milk) { Models::Product.new(name: 'Milk', price: 397) }
  let(:bread) { Models::Product.new(name: 'bread', price: 217) }
  let(:banana) { Models::Product.new(name: 'banana', price: 99) }
  let(:apple) { Models::Product.new(name: 'Apple', price: 89) }

  let(:milk_sale) { Models::Sale.new(product_uid: milk.uid, quantity: 2, price: 500) }
  let(:bread_sale) { Models::Sale.new(product_uid: bread.uid, quantity: 3, price: 600) }

  let(:products) { [milk, bread, banana, apple] }
  let(:sales) { [milk_sale, bread_sale] }
  let(:product_uids) { [milk.uid, milk.uid, bread.uid, banana.uid, bread.uid, bread.uid, bread.uid, milk.uid, apple.uid] }
  let(:cart) { Models::Cart.new(product_uids: product_uids) }

  let(:compute) { Services::Compute.new(products: products, sales: sales, cart: cart) }

  before { compute.totals }

  describe '#totals' do
    it 'calculates the correct total values', :aggregate_failures do
      expect(compute.total_savings).to eq 345
      expect(compute.total_price).to eq 1902
    end

    it 'calculates the correct #regular_price', :aggregate_failures do
      expect(compute.items.dig(milk.uid.to_sym, :regular_price)).to eq 1191
      expect(compute.items.dig(bread.uid.to_sym, :regular_price)).to eq 868
      expect(compute.items.dig(banana.uid.to_sym, :regular_price)).to eq 99
      expect(compute.items.dig(apple.uid.to_sym, :regular_price)).to eq 89
    end

    it 'calculates the correct #sales_price', :aggregate_failures do
      expect(compute.items.dig(milk.uid.to_sym, :sales_price)).to eq 897
      expect(compute.items.dig(bread.uid.to_sym, :sales_price)).to eq 817
      expect(compute.items.dig(banana.uid.to_sym, :sales_price)).to be_nil
      expect(compute.items.dig(apple.uid.to_sym, :sales_price)).to be_nil
    end

    it 'calculates the correct #savings', :aggregate_failures do
      expect(compute.items.dig(milk.uid.to_sym, :savings)).to eq 294
      expect(compute.items.dig(bread.uid.to_sym, :savings)).to eq 51
      expect(compute.items.dig(banana.uid.to_sym, :savings)).to eq 0
      expect(compute.items.dig(apple.uid.to_sym, :savings)).to eq 0
    end
  end
end
