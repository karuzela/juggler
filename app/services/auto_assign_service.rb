class AutoAssignService
  def initialize(pull_request)
    @pull_request = pull_request
  end

  def call
    return false if @pull_request.reviewer? || !@pull_request.pending?
    update_pull_request
    send_slack_message
    send_email_messsage

    true
  end

  private
  def update_pull_request
    @pull_request.update(reviewer: User.all.sample)
  end

  def send_slack_message
    SlackClient.new("You are auto assigned to PR review", @pull_request.reviewer.slack_username)
  end

  def send_email_messsage

  end
end