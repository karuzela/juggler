class ReminderService
  def initialize(pull_request)
    @pull_request = pull_request
  end

  def call
    return false unless @pull_request.pending?
    send_slack_message
    send_email_messsage
  end

  private
  def send_slack_message
    slack = SlackClient.new()
    slack.send_message("Recall about pull request to review!", @pull_request.reviewer.slack_channel)
  end

  def send_email_messsage
    NotificationMailer.reminder(@pull_request).deliver_now
  end
end