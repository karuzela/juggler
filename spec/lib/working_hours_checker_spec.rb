require 'rails_helper'

describe WorkingHoursChecker do
  let(:working_date) { Time.new(2015, 12, 21, 8) }
  let(:next_day_date) { Time.new(2015, 12, 21, 18) }
  let(:next_day_date2) { Time.new(2015, 12, 21, 17, 30) }
  let(:next_week_date) { Time.new(2015, 12, 25, 18) }

  it 'should send notifications in 3 hours' do
    checker = WorkingHoursChecker.new(date: working_date)
    expect(checker.get_date).to eq(Time.new(2015, 12, 21, 11))
  end

  it 'should send notifications in 10 hours' do
    checker = WorkingHoursChecker.new(date: working_date, delay: 10)
    expect(checker.get_date).to eq(Time.new(2015, 12, 21, 18))
  end

  it 'should send notifications next day at 8am' do
    checker1 = WorkingHoursChecker.new(date: next_day_date)
    checker2 = WorkingHoursChecker.new(date: next_day_date2)
    expect(checker1.get_date).to eq(Time.new(2015, 12, 22, 8))
    expect(checker2.get_date).to eq(Time.new(2015, 12, 22, 8))
  end

  it 'should send notifications next monday at 8am' do
    checker = WorkingHoursChecker.new(date: next_week_date)
    expect(checker.get_date).to eq(Time.new(2015, 12, 28, 8))
  end
end