Dir[Rails.root.join("lib/extensions/**/*.rb")].each { |extension| require extension }

print "EXTENSIONS..."
puts "OK".green
