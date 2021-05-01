def display_application_info
  message = "csv importer api".upcase
  version = "1.0"
  decorators_times = 29

  print "\n"
  puts ("#"*decorators_times).yellow
  print "#".yellow
  print " #{message} "
  print "v#{version} ".cyan
  puts "#".yellow
  puts ("#"*decorators_times).yellow
  print "\n"
end

display_application_info()