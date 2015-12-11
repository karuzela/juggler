class AutoAssignWorker
  include Sidekiq::Worker

  def perform(pull_request_id)
    pull_request = PullRequest.find(pull_request_id)
    AutoAssignService.new(pull_request).call
  end
end