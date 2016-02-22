class SendSlackMessageService
  def initialize(pull_request, message_type)
    @slack = SlackClient.new
    @pull_request = pull_request
    @message_type = message_type
    @url = Rails.application.routes.url_helpers.pull_request_url(@pull_request, host: ENV["ACTION_MAILER_HOST"])
  end

  def call
    @slack.send_message(
      message(@message_type),
      attachments: [SlackAttachmentBuilder.build(@pull_request)],
      channel: channel(@message_type)
    )
  end

  private

  def message(message_type)
    case message_type
    when :auto_assign
      "Hey! You were auto-assigned to review this pull request. [Click here for details](#{@url})"
    when :reminder
      "Hey! Remember to review this pull request. Do not test my patience. [Details are here](#{@url})"
    when :pr_updated
      "Hey! This pull request was updated. [Click here for details](#{@url})"
    when :new_pr
      "Greetings *Visuality Team*. New pull request is ready for code review. To claim it [click here](#{@url}) or type \`juggler:claim #{@pull_request.token}\` on this channel."
    end
  end

  def channel(message_type)
    case message_type
    when :new_pr
      default_channel
    else
      @pull_request.reviewer.try(:slack_channel)
    end
  end

  def default_channel
    ENV["SLACK_DEFAULT_CHANNEL"]
  end
end
