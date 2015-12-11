class ReminderWorker
  include Sidekiq::Worker

  def perform(pull_request_id)
    pull_request = PullRequest.find(pull_request_id)
    ReminderService.new(pull_request).call
  end
end