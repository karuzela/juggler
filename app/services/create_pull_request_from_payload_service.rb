class CreatePullRequestFromPayloadService

  def initialize(payload, opts={})
    @payload = payload
  end

  def call
    if @payload['pull_request'].present?
      pr = PullRequest.find_by_github_id(@payload['pull_request']['id'])
      if pr.nil?
        PullRequest.create(pr_params(@payload))
        send_slack_info_message
      else
        pr.update_attribute :state, 'pending'
      end
    end
  end

  private

  def pr_params(payload)
    pr_hash = {}
    pr_hash[:state] = 'pending'
    pr_hash[:github_id] = payload['pull_request']['id']
    pr_hash[:opened_at] = payload['pull_request']['created_at']
    pr_hash[:title] = payload['pull_request']['title']
    pr_hash[:body] = payload['pull_request']['body']
    pr_hash[:repository_id] = Repository.find_by_github_id(payload['repository']['id']).id
    return pr_hash
  end

  def send_slack_info_message
    slack = SlackClient.new()
    slack.send_message("New PR to review")
  end
end