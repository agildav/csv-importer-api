Dir[Rails.root.join("lib/helpers/**/*.rb")].each { |helper| require helper }

print "HELPERS..."
puts "OK".green
