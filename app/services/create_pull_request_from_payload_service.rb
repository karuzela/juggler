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
    pr_hash = {
      :state => 'pending',
      :opened_at => payload['pull_request']['created_at'],
      :title => payload['pull_request']['title'],
      :body => payload['pull_request']['body']
    }
    pr_hash[:repository_id] = Repository.find_by_github_id(payload['repository']['id']).id
    return pr_hash
  end

  def send_slack_info_message
    slack = SlackClient.new()
    slack.send_message("New PR to review")
  end
end