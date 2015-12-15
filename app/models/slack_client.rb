require 'slack-notifier'
class SlackClient
  def initialize
    @notifier = Slack::Notifier.new(
      ENV["SLACK_WEBHOOK_URL"],
      channel: ENV["SLACK_DEFAULT_CHANNEL"],
      username: 'juggler',
      icon_emoji: ":robot_face:"
    )
  end

  def send_message(message, channel: ENV["SLACK_DEFAULT_CHANNEL"], attachments:)
    @notifier.ping message, channel: channel, attachments: attachments
  end
end
