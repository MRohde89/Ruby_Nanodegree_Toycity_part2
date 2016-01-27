require 'json'
require 'colorize' ## needs to be installed first in the command line sudo gem install colorize

def setup_files
	path = File.join(File.dirname(__FILE__), '../data/products.json')
	file = File.read(path)
	$products_hash = JSON.parse(file)
	$report_file = File.new("report.txt", "w+")
end

def gather_data
		main_data = $products_hash['items'][0..$products_hash['items'].length]
		unique_brands = main_data.map { |item| item['brand']}.uniq
		brands_data_hash = []
		products_data_hash = [] ## strangely the array must be defined on this level as well in order to be available after the loop
		unique_brands.each do |brands|
			all_brand_products = main_data.select { |product| product['brand'] == brands}
			#products_data_hash = []
			brand_stocks = 0
			brand_ave_price = 0
			brand_total_sales = 0
			all_brand_products.each do |brand_product|
						total_of_purchases, total_of_sales = data_from_purchases(brand_product['purchases'])
						### creating products hash
						products_data_hash.push({
							brand: brand_product['brand'],
							title: brand_product['title'],
						  retail_price: retail_price = brand_product['full-price'].to_f,
							total_purchases: total_of_purchases,
							total_sales: total_of_sales,
						  ave_price: average_price = (total_of_sales/total_of_purchases).round(2),
							ave_discount: ((1-average_price/retail_price)*100).round(2),
							stock: brand_product['stock'] })
						### brand aggregations
						brand_stocks += brand_product['stock']
						brand_ave_price += average_price
						brand_total_sales += total_of_sales
			end
			### creating brand hash
			brands_data_hash.push({
				brand: brands,
				stock: brand_stocks.round(2),
				ave_price: (brand_ave_price/all_brand_products.length).round(2),
				sales: brand_total_sales.round(2)
		})

		end
		output_to_file(products_data_hash, brands_data_hash)
end

def data_from_purchases(purchases)
	# get sum of prices for
	total_of_sales = purchases.map { |hash| hash['price']}.reduce(:+)
	total_of_purchases = purchases.length
	return  total_of_purchases, total_of_sales
end


def output_to_file (products_hash, brands_hash)
	$report_file.puts("PRODUCTS".force_encoding(Encoding::ASCII))
	products_section(products_hash)
	end_of_section
	$report_file.puts("BRANDS".force_encoding(Encoding::ASCII))
	brands_section(brands_hash)
	end_of_section
	$report_file.puts 'THIS REPORT HAS BEEN CREATED BY MROHDE'
end

def products_section (products_hash)
	#puts products_hash
	index = 1
	products_hash.each do |product|
		$report_file.puts "-------TOY #{index}-------"
		$report_file.puts "Name of Toy: #{ product[:title] }"
		$report_file.puts "Retail Price: #{product[:retail_price]}"
		$report_file.puts "Total \# of Purchases: #{product[:total_purchases]}"
		$report_file.puts "Total amount of Sales: #{product[:total_sales]}"
		$report_file.puts "Average Price: #{product[:ave_price]}"
		$report_file.puts "Average Discount: #{product[:ave_discount]}"
		$report_file.puts
		index +=1
	end
end

def brands_section (brands_hash)
	index = 1
	brands_hash.each do |brand|
		$report_file.puts "-------BRAND #{index}-------"
		$report_file.puts "Name of Brand: #{ brand[:brand] }"
		$report_file.puts "\# in Stock: #{ brand[:stock] }"
		$report_file.puts "Average Price #{ brand[:ave_price] }"
		$report_file.puts "TOTAL SALES: #{ brand[:sales] }"
		$report_file.puts
		index +=1
	end
end

def end_of_section
	$report_file.puts("-------END OF SECTION-------")
	$report_file.puts
end

setup_files
gather_data



# def make_products_section
# # For each product in the data set:
# 	# Print "Products" in ascii art
# 	# Print the name of the toy
# 	# Print the retail price of the toy
# 	# Calculate and print the total number of purchases
# 	# Calculate and print the total amount of sales
# 	# Calculate and print the average price the toy sold for
# 	# Calculate and print the average discount (% or $) based off the average sales price
# 	puts "Products".force_encoding(Encoding::ASCII).colorize( :blue )
# 	products = []
# 	$products_hash['items'].each do |product|
# 		total_of_purchases, total_of_sales = data_from_purchases(product['purchases'])
# 		products.push(  { brand: product['brand'],
# 		title: product['title'],
# 	  retail_price: retail_price = product['full-price'].to_f,
# 		total_purchases: total_of_purchases,
# 		total_sales: total_of_sales,
# 	  ave_price: average_price = (total_of_sales/total_of_purchases).round(2),
# 		ave_discount: ((1-average_price/retail_price)*100).round(3),
# 		stock: product['stock']
# 	})
# 	end
# 	make_brands_section(products)
# end
#
#
# def data_from_purchases(purchases)
# 	# get sum of prices for
# 	total_of_sales = purchases.map { |hash| hash['price']}.reduce(:+)
# 	total_of_purchases = purchases.length
# 	return  total_of_purchases, total_of_sales
# end
#
# def make_brands_section(products)
#  #Print "Brands" in ascii art
#
#  # For each brand in the data set:
# 	 # Print the name of the brand
# 	 # Count and print the number of the brand's toys we stock
# 	 # Calculate and print the average price of the brand's toys
# 	 # Calculate and print the total sales volume of all the brand's toys combined
#  	unique_brands = products.map { |product| product[:brand] }.uniq
# 	puts unique_brands
# 	brands_hash = []
# 	unique_brands.each do |brands|
# 		brand_overview = products.select{|key| key[:brand] == brands }
# 		puts "-------"
# 		puts brand_overview
# 		brands_hash.push({
# 			brand: brands#,
# 			#stock: brand_overview.map{ |key| key[:stock].to_f}.reduce(:+)}
# 		})
# 	end
# end

#setup_files
#make_products_section
