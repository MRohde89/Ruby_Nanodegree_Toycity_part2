require 'json'

### THIS METHOD READS IN THE PRODUCTS FILE
def setup_files
	path = File.join(File.dirname(__FILE__), '../data/products.json')
	file = File.read(path)
	$products_hash = JSON.parse(file)
	$report_file = File.new("report.txt", "w+")
end


#### THIS METHOD TAKES THE PRODUCTS FILE AND GATHERS/CALCULATE ALL THE NECESSARY INFORMATION FOR LATER USE
def gather_data
		main_data = $products_hash['items'][0..-1]
		unique_brands = main_data.map { |item| item['brand']}.uniq # only unique brands for the brands section
		brands_data_hash  = [] # empty array which will be filled with data from products ...
    products_data_hash = [] # ... and brands
    unique_brands.each do |brands|
			all_brand_products = main_data.select { |product| product['brand'] == brands} # only select one brand
			brand_stocks = brand_total_purchases = brand_total_sales = 0
			all_brand_products.each do |brand_product| # loop through product of the brand
						### creating products hash
						products_data_hash.push(_products_data(brand_product))
						### brand aggregations for later use
						brand_stocks += products_data_hash[-1][:stock]
						brand_total_purchases += products_data_hash[-1][:total_purchases]
						brand_total_sales += products_data_hash[-1][:total_sales]
			end
			### creating brand hash
			brands_data_hash.push(_brands_hash(brands,brand_stocks,brand_total_purchases,brand_total_sales))
		end
    return products_data_hash, brands_data_hash
end


### THIS METHOD CALCULATES ALL RELEVENAT PRODUCT KPI AND RETURNS IT TO _products_data
def _calculate_products_data (brand_product)
	total_of_purchases, total_of_sales = data_from_purchases(brand_product['purchases'])
  retail_price = brand_product['full-price'].to_f
	average_price = (total_of_sales/total_of_purchases).round(2)
  average_discount = ((1-average_price/retail_price)*100).round(2)
	return total_of_purchases, total_of_sales, retail_price, average_price, average_discount
end


### THIS METHOD CREATES AN HASH WITH THE RELEVANT DATA FOR THE PRODUCTS
def _products_data (brand_product)
  total_of_purchases, total_of_sales, retail_price, average_price, average_discount = _calculate_products_data(brand_product)
	return {
		brand: brand_product['brand'],
		title: brand_product['title'],
		retail_price: retail_price,
		total_purchases: total_of_purchases,
		total_sales: total_of_sales,
		ave_price: average_price,
		ave_discount: average_discount,
		stock: brand_product['stock'] }
end

### THIS METHOD CREATES/CALCULATES AN HASH WITH THE RELEVANT DATA FOR THE BRAND
def _brands_hash (brands,brand_stocks,brand_total_purchases,brand_total_sales)
  brand_ave_price = (brand_total_sales/brand_total_purchases).round(2)
  return {
    brand: brands,
    stock: brand_stocks.round(2),
    ave_price: brand_ave_price,
    sales: brand_total_sales.round(2)
    }
end

### THIS METHOD TAKES THE PURCHASES DATA FROM THE PRODUCTS FILE AND AGGREGATES SALES AND NUMBER OF PURCHASES
def data_from_purchases(purchases)
	total_of_sales = purchases.map { |hash| hash['price']}.reduce(:+) # sum over prices
	total_of_purchases = purchases.length # number of purchases
	return  total_of_purchases, total_of_sales
end

### THIS METHOD TAKES THE products_hash AND brands_hash AND GENERATES THE FINAL OUTPUT
def output_to_file (products_hash, brands_hash)
	_sales_report_header
	_products_header
	products_section(products_hash)
	end_of_section
	_brands_header
	brands_section(brands_hash)
	end_of_section
	$report_file.puts 'THIS REPORT HAS BEEN CREATED BY MROHDE'
end

### THIS METHOD TAKES THE products_hash AND WRITES THE NECESSARY INFORMATION TO THE FILE
def products_section (products_hash)
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

### THIS METHOD TAKES THE brands_hash AND WRITES THE NECESSARY INFORMATION TO THE FILE
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

### THIS METHOD GENERATES A PLACEHOLDER AT THE END OF EACH SECTION
def end_of_section
	$report_file.puts("-------END OF SECTION-------")
	$report_file.puts
end

### THIS METHOD CREATES THE SALES REPORT HEADER
def _sales_report_header
	$report_file.puts "    _____       _            _____                       _ "
	$report_file.puts "   / ____|     | |          |  __ \\                     | |"
	$report_file.puts "  | (___   __ _| | ___ ___  | |__) |___ _ __   ___  _ __| |_ "
	$report_file.puts "   \\___ \\ / _` | |/ _ \\ __| |  _  // _ \\ '_ \\ / _ \\| '__| __|"
	$report_file.puts "   ____) | (_| | |  __\\__ \\ | | \\ \\  __/ |_) | (_) | |  | |_ "
	$report_file.puts "  |_____/ \\__,_|_|\\___|___/ |_|  \\_\\___| .__/ \\___/|_|   \\__|"
	$report_file.puts "                                       | |                   "
	$report_file.puts "                                       |_|                   	"
	$report_file.puts
	$report_file.puts "--------------------------------------------------------------------"
	$report_file.puts "--------------------------------------------------------------------"
	$report_file.puts
end

### THIS METHOD CREATES THE PRODUCT HEADER
def _products_header

	$report_file.puts "                     _            _       "
	$report_file.puts "                    | |          | |      "
	$report_file.puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
	$report_file.puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
	$report_file.puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
	$report_file.puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
	$report_file.puts "| |                                       "
	$report_file.puts "|_|                                       "
	$report_file.puts
	$report_file.puts "--------------------------------------------------------------------"
	$report_file.puts
end

### THIS METHOD CREATES THE BRANDS HEADER
def _brands_header
	$report_file.puts " _                         _     "
	$report_file.puts "| |                       | |    "
	$report_file.puts "| |__  _ __ __ _ _ __   __| |___ "
	$report_file.puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	$report_file.puts "| |_) | | | (_| | | | | (_| \\__ \\"
	$report_file.puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
	$report_file.puts
	$report_file.puts "--------------------------------------------------------------------"
	$report_file.puts
end


### START THE PROCESS
def start
	setup_files # reading the file
	products_data_hash,brands_data_hash = gather_data # manipulation of that dataset. Returns values because it is easier to read that way.
	output_to_file(products_data_hash,brands_data_hash) # output to file
end

### TO START
start
