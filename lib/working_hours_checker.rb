class WorkingHoursChecker
  WORKING_FROM = 8
  WORKING_TO = 20

  def initialize(opts={})
    @date = opts[:date] || Time.now
    @delay = opts[:delay] ? opts[:delay].to_i : 3
  end

  def get_date
    @day_of_week = @date.strftime("%u").to_i
    @notification_hour = @date.strftime("%k").to_i + @delay

    if notification_in_working_hours?
      return @date + @delay.hours
    else
      return next_available_date
    end
  end

  private

  def next_available_date
    if @day_of_week == 5
      (@date + 3.days).change(hour: 8)
    else
      (@date + 1.day).change(hour: 8)
    end
  end

  def notification_in_working_hours?
    (1..5).to_a.include?(@day_of_week) && @notification_hour >= WORKING_FROM && @notification_hour < WORKING_TO
  end
end
