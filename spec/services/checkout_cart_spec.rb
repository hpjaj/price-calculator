require 'spec_helper'

RSpec.describe Services::CheckoutCart do
  let(:milk) { Models::Product.new(name: 'Milk', price: 397) }
  let(:bread) { Models::Product.new(name: 'bread', price: 217) }
  let(:milk_sale) { Models::Sale.new(product_uid: milk.uid, quantity: 2, price: 500) }

  let(:products) { [milk, bread] }
  let(:sales) { [milk_sale] }
  let(:items) { 'milk,milk, bread' }

  let(:checkout) { Services::CheckoutCart.new(products: products, sales: sales, items: items) }

  describe '#process_items' do
    context 'happy path' do
      it 'returns true' do
        expect(checkout.process_items).to eq true
      end

      it '#error is nil' do
        checkout.process_items

        expect(checkout.error).to be_nil
      end
    end

    context 'when the #list is empty' do
      let(:items) { '' }

      it 'returns false' do
        expect(checkout.process_items).to eq false
      end

      it 'sets #error' do
        checkout.process_items

        expect(checkout.error).to_not be_empty
      end
    end

    context 'when the #list contains an item that we do not sell' do
      let(:items) { 'milk, grapes' }

      it 'returns false' do
        expect(checkout.process_items).to eq false
      end

      it 'sets #error' do
        checkout.process_items

        expect(checkout.error).to_not be_empty
      end
    end
  end
end
