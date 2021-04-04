require 'spec_helper'

RSpec.describe Services::GroceryList do
  let(:milk) { Models::Product.new(name: 'Milk', price: 397) }
  let(:bread) { Models::Product.new(name: 'bread', price: 217) }
  let(:banana) { Models::Product.new(name: 'banana', price: 99) }
  let(:apple) { Models::Product.new(name: 'Apple', price: 89) }
  let(:products) { [milk, bread, banana, apple] }
  let(:items) { 'milk,milk, bread,banana,bread,bread,bread,milk,apple' }
  let(:grocery_list) { Services::GroceryList.new(items: items, products: products) }

  describe '#add_to_cart!' do
    context 'happy path' do
      it 'returns an instance of Cart' do
        results = grocery_list.add_to_cart!

        expect(results.class).to eq Models::Cart
      end

      it 'parses the string into an array of Product#uids' do
        grocery_list.add_to_cart!

        expect(grocery_list.send(:uids)).to contain_exactly(
          'milk', 'milk', 'bread', 'banana', 'bread', 'bread', 'bread', 'milk', 'apple'
        )
      end
    end

    context 'when the #list is empty' do
      let(:items) { '' }

      it 'raises an ArgumentError' do
        expect { grocery_list.add_to_cart! }.to raise_error(ArgumentError)
      end
    end

    context 'when the #list contains an item that we do not sell (i.e. no matching Product)' do
      let(:items) { 'milk, grapes' }

      it 'raises an ArgumentError' do
        expect { grocery_list.add_to_cart! }.to raise_error(ArgumentError)
      end
    end

    context 'when the #list contains unexpected charaters' do
      let(:items) { 'Milk, apples!, 10x the Fun, \<script>document.querySelector(#root)\</script>, $%^&*()[]' }

      it 'strips all characters that are not-alphanumeric or a comma' do
        expect(grocery_list.send(:sanitize)).to eq 'Milk,apples,10xtheFun,scriptdocumentquerySelectorrootscript,'
      end
    end
  end
end
