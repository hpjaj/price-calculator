require_relative './models/product'
require_relative './models/sale'
require_relative './services/checkout_cart'


###################################################################################
##################################  Setup Store  ##################################
###################################################################################

milk   = Models::Product.new(name: 'Milk', price: 397)
bread  = Models::Product.new(name: 'Bread', price: 217)
banana = Models::Product.new(name: 'Banana', price: 99)
apple  = Models::Product.new(name: 'Apple', price: 89)

milk_sale  = Models::Sale.new(product_uid: milk.uid, quantity: 2, price: 500)
bread_sale = Models::Sale.new(product_uid: bread.uid, quantity: 3, price: 600)

products = [milk, bread, banana, apple]
sales    = [milk_sale, bread_sale]


###################################################################################
##################################  Prompt User  ##################################
###################################################################################

puts 'Please enter all the items purchased separated by a comma'
items = gets.chomp


###################################################################################
#############################  Checkout Their Buggy  ##############################
###################################################################################

checkout = Services::CheckoutCart.new(products: products, sales: sales, items: items)

if checkout.process_items
  checkout.provide_receipt
else
  puts checkout.error
end
