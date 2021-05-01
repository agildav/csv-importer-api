desc "Run all files in db/seeds directory"
namespace :db do
  desc "Joins the seed information and loads it in the database"
  task :seed => :environment do
    #   :seed - Seeds the initial data
    #
    #   Example:
    #   - rake db:seed
    begin
      starting = TimeHelper.get_time

      # List of seeds filenames
      [
        "user"
      ].each do |filename|
          file = File.join(Rails.root, "db", "seeds", "#{filename}_seeds.rb")
          puts "Seeding - #{file} ..."
          load file if File.exist? file
        end
      puts "\nSeed complete! in #{TimeHelper.get_elapsed_time(starting)} minutes".green
    rescue => exception
      puts "\nERROR in task: \n".red
      puts exception.backtrace
      puts exception.message.red
      puts ":-FailedTask"
      exit(1)
    end
  end

  desc "Runs only one seed file and loads it to the database"
  task :single, [:file] => :environment do |t, args|
    #   :seed - Seeds the initial data
    #
    #   Example:
    #   - rake 'db:single[user]'
    unless args.empty?
      begin
        starting = TimeHelper.get_time

        file = File.join(Rails.root, "db", "seeds", "#{args.file}_seeds.rb")
        puts "Seeding #{file} ..."
        load file if File.exist? file

        puts "\nSeed complete! in #{TimeHelper.get_elapsed_time(starting)} minutes".green
      rescue => exception
        puts "\nERROR in task: \n".red
        puts exception.backtrace
        puts exception.message.red
        puts ":-FailedTask"
        exit(1)
      end
    end
  end
end
