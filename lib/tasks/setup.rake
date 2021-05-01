namespace :setup do
  desc "Drops, creates and reloads database | Runs seeds"
  task :reset => :environment do |t, args|
    begin
      puts "Resetting database".yellow
      Rake::Task["db:drop"].invoke
      puts "Done".yellow
      Rake::Task["db:create"].invoke
      puts "Done".yellow
      Rake::Task["setup:init"].invoke
    rescue => exception
      puts "\nERROR in task: \n".red
      puts exception.backtrace
      puts exception.message.red
      puts ":-FailedTask"
      exit(1)
    end
  end

  desc "Drops, creates and reloads database"
  task :reset_without_seeds => :environment do |t, args|
    begin
      puts "Resetting database".yellow
      Rake::Task["db:drop"].invoke
      puts "Done".yellow
      Rake::Task["db:create"].invoke
      puts "Done".yellow
      Rake::Task["setup:init_without_seeds"].invoke
    rescue => exception
      puts "\nERROR in task: \n".red
      puts exception.backtrace
      puts exception.message.red
      puts ":-FailedTask"
      exit(1)
    end
  end

  desc "Reloads database | Runs seeds"
  task :init => :environment do |t, args|
    print "Executing "
    print "setup:init ".yellow
    print "in: "
    puts Rails.env.yellow

    puts "This will reload the schema in existing database".red
    begin
      starting = TimeHelper.get_time
      run_setup_init
      puts "\nSetup complete! in #{TimeHelper.get_elapsed_time(starting)} minutes".green
    rescue => exception
      puts "\nERROR in task: \n".red
      puts exception.backtrace
      puts exception.message.red
      puts ":-FailedTask"
      exit(1)
    end
  end

  desc "Reloads database"
  task :init_without_seeds => :environment do |t, args|
    print "Executing "
    print "setup:init ".yellow
    print "in: "
    puts Rails.env.yellow

    puts "This will reload the schema in existing database".red
    begin
      starting = TimeHelper.get_time
      run_setup_init_without_seeds
      puts "\nSetup complete! in #{TimeHelper.get_elapsed_time(starting)} minutes".green
    rescue => exception
      puts "\nERROR in task: \n".red
      puts exception.backtrace
      puts exception.message.red
      puts ":-FailedTask"
      exit(1)
    end
  end

  private

  def run_setup_init_without_seeds
    reload_schema
    sql_init_database
  end

  def run_setup_init
    run_setup_init_without_seeds
    run_seeds
  end

  def reload_schema
    schema_format = "structure"

    puts ("=" * 30).yellow
    puts "Re-loading schema in existing database".red
    system "DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rake db:#{schema_format}:load"
    puts "Schema re-loaded".green
    puts ("=" * 30).yellow
  end

  def sql_init_database
    system "DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rake sql:run_sql"
    system "DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=test rake sql:run_sql"
  end

  def run_seeds
    system "DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rake db:seed"
    system "DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=test rake db:seed"
  end
end
