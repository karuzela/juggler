class SendSlackMessageService
  def initialize(pull_request, message_type)
    @slack = SlackClient.new
    @pull_request = pull_request
    @message_type = message_type
    @url = Rails.application.routes.url_helpers.pull_request_url(@pull_request, host: ENV["ACTION_MAILER_HOST"])
    p 'DEBUG'
    p pull_request
    p message_type
  end

  def call
    attachments = [SlackAttachmentBuilder.build(@pull_request)]
    message = config[@message_type][:message]
    channel = config[@message_type][:channel]

    @slack.send_message(
      message,
      attachments: attachments,
      channel: channel
    )
  end

  private

  def config
    {
      auto_assign: {
        message: "Hey! You were auto-assigned to review this pull request. [Click here for details](#{@url})",
        channel: @pull_request.reviewer.try(:slack_channel)
      },
      reminder: {
        message: "Hey! Remember to review this pull request. Do not test my patience. [Details are here](#{@url})",
        channel: @pull_request.reviewer.try(:slack_channel)
      },
      pr_updated: {
        message: "Hey! This pull request was updated. [Click here for details](#{@url})",
        channel: @pull_request.reviewer.try(:slack_channel)
      },
      new_pr: {
        message: "Greetings *Visuality Team*. New pull request is ready for code review. To claim it [click here](#{@url}) or type \`juggler:claim #{@pull_request.token}\` on this channel.",
        channel: default_channel
      }
    }
  end

  def default_channel
    ENV["SLACK_DEFAULT_CHANNEL"]
  end
end
