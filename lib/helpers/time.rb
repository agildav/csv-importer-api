class TimeHelper
  def self.to_hour_and_minutes(datetime)
    datetime ||= Time.current
    datetime.strftime('%H:%M')
  end

  def self.get_time
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end

  def self.get_elapsed_time(starting_time)
    ((get_time - starting_time) / 60.0).round(2)
  end
end
