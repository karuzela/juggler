FactoryGirl.define do
  factory :repository do
    sequence(:name) { |number| "Repository ##{number}" }
    sequence(:html_url) { |number| "https://github.com/username/project-name-#{number}" }
    sequence(:git_url) { |number| "git@github.com:username/project-name-#{number}.git" }
    sequence(:owner) { |number| "github-username-#{number}" }
    sequence(:full_name) { |number| "username/project-name-#{number}" }
    sequence(:github_id) { |number| number }
    sequence(:claim_time) { |number| number }
    sequence(:remind_time) { |number| number }
    synchronized true
  end
end
