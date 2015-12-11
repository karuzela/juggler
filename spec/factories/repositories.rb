FactoryGirl.define do
  factory :repository do
    sequence(:name) { |number| "Repository ##{number}" }
    sequence(:home_url) { |number| "https://github.com/username/project-name-#{number}" }
    sequence(:git_url) { |number| "git@github.com:username/project-name-#{number}.git" }
    sequence(:owner) { |number| "github-username-#{number}" }
    synchronized true
  end
end
