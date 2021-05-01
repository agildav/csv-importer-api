namespace :sql do
  desc "Executes SQL on database"
  task :run_sql => :environment do |t, args|
    begin
      starting = TimeHelper.get_time

      puts "Init SQL".yellow

      # do something

      puts "End SQL".yellow
      puts "\nSQL complete! in #{TimeHelper.get_elapsed_time(starting)} minutes".green
    rescue => exception
      puts "\nERROR in task: \n".red
      puts exception.backtrace
      puts exception.message.red
      puts ":-FailedTask"
      exit(1)
    end
  end
end
