require 'json'
require 'colorize' ## needs to be installed first in the command line sudo gem install colorize

def setup_files
	path = File.join(File.dirname(__FILE__), '../data/products.json')
	file = File.read(path)
	$products_hash = JSON.parse(file)
	$report_file = File.new("report.txt", "w+")
end

def start
	#setup_files
	#create_report
end


def create_report
	#print_heading
	#print_data
end

def print_heading
	## print the heading
end

def print_data
	## print the data
	#make_products_section
	#make_brands_section
end







# Print "Sales Report" in ascii art

puts "Sales Report".force_encoding(Encoding::ASCII).colorize( :blue )

# Print today's date

puts Time.now.strftime("Printed on %m/%d/%Y")

# Print "Products" in ascii art




# For each product in the data set:
	# Print the name of the toy
	# Print the retail price of the toy
	# Calculate and print the total number of purchases
	# Calculate and print the total amount of sales
	# Calculate and print the average price the toy sold for
	# Calculate and print the average discount (% or $) based off the average sales price

# Print "Brands" in ascii art

# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined
