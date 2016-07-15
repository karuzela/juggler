FactoryGirl.define do
  factory :pull_request do
    repository
    state { PullRequestState::PENDING }
    sequence(:title) { |number| "Pull request title #{number}" }
    body "Pull request body"
    token { SecureRandom.urlsafe_base64 }
    opened_at { Time.now }
  end
end
