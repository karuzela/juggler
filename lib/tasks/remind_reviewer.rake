namespace :remind_reviewer do
  desc "Send reminder to reviewers"
  task send: :environment do
    pull_requests = PullRequest.where(state: PullRequestState::PENDING)
      .where.not(reviewer_id: nil)
      .where('assigned_at < ?', Date.today)
    pull_requests.each do |pull_request|
      ReminderService.new(pull_request).call
    end
  end
end