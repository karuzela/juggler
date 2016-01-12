FactoryGirl.define do
  factory :user do
    sequence(:email) { |number| "sample_#{number}@sample.pl" }
    sequence(:name) { |number| "sample_#{number}" }
    github_id nil
    github_access_token nil
    password 'secret123'
  end
end
