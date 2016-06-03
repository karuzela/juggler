FactoryGirl.define do
  factory :pull_request do
    repository
    state { PullRequestState::PENDING }
    sequence(:title) { |number| "Pull request title #{number}" }
    body "Pull request body"
    opened_at { Time.now }
    sequence(:token) { |number| number }
    reviewer { create(:user) }
  end
end
