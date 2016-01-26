require 'json'
require 'colorize' ## needs to be installed first in the command line sudo gem install colorize

def setup_files
	path = File.join(File.dirname(__FILE__), '../data/products.json')
	file = File.read(path)
	$products_hash = JSON.parse(file)
	$report_file = File.new("report.txt", "w+")
end
#
# def start
# 	setup_files
# 	create_report
# end
#
#
# def create_report
# 	print_heading
# 	print_data
# end
#
# def print_heading
# 	# Print today's date
# 	puts Time.now.strftime("Printed on %m/%d/%Y")
# 	# Print "Sales Report" in ascii art
# 	puts "Sales Report".force_encoding(Encoding::ASCII).colorize( :blue )
# 	# Print "Products" in ascii art
# 	puts "Products".force_encoding(Encoding::ASCII).colorize( :blue )
# 	print_data
# end
#
# def print_data
# 	## print the data
# 	make_products_section
# 	make_brands_section
# end

def make_products_section
# For each product in the data set:
	# Print the name of the toy
	# Print the retail price of the toy
	# Calculate and print the total number of purchases
	# Calculate and print the total amount of sales
	# Calculate and print the average price the toy sold for
	# Calculate and print the average discount (% or $) based off the average sales price
	$products_hash['items'].each do |product|
		puts product['title']
		puts retail_price = product['full-price'].to_f
		total_of_purchases, total_of_sales = data_from_purchases(product['purchases'])
		puts total_of_purchases
		puts total_of_sales
		puts average_price = (total_of_sales/total_of_purchases).round(2)
		puts average_discount = ((1-average_price/retail_price)*100).round(3)
	end
end


def data_from_purchases(purchases)
	# get sum of prices for
	total_of_sales = purchases.map { |hash| hash['price']}.reduce(:+)
	total_of_purchases = purchases.length
	return  total_of_purchases, total_of_sales
end


setup_files
make_products_section



# Print "Brands" in ascii art

# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined
