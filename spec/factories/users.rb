FactoryGirl.define do
  factory :user do
    sequence(:email) { |number| "sample_#{number}@sample.pl" }
    sequence(:name) { |number| "sample_#{number}" }
    password 'secret123'
  end
end
