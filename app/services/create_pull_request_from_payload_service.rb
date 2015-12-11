class CreatePullRequestFromPayloadService

  def initialize(payload, opts={})
    @payload = payload
  end

  def call
    PullRequest.find_or_create_by(pr_params(@payload))
    send_slack_info_message
  end

  private

  def pr_params(payload)
    pr_hash = {}
    pr_hash[:state] = 'pending'
    pr_hash[:opened_at] = payload['pull_request']['created_at'] if payload['pull_request'].present?
    pr_hash[:title] = payload['pull_request']['title'] if payload['pull_request'].present?
    pr_hash[:body] = payload['pull_request']['body'] if payload['pull_request'].present?
    pr_hash[:repository_id] = Repository.find_by_github_id(payload['repository']['id']).id if payload['repository'].present?
    return pr_hash
  end

  def send_slack_info_message
    slack = SlackClient.new()
    slack.send_message("New PR to review")
  end
end