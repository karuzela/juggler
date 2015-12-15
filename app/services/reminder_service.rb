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
    url = Rails.application.routes.url_helpers.pull_request_url(@pull_request, host: ENV["ACTION_MAILER_HOST"])
    attachments = [SlackAttachmentBuilder.build(@pull_request)]

    slack.send_message(
      "Hey! Remember to review this pull request. Do not test my patience. [Details are here](#{url})",
      attachments: attachments,
      channel: @pull_request.reviewer.slack_channel
    )
  end

  def send_email_messsage
    NotificationMailer.reminder(@pull_request).deliver_now
  end
end
