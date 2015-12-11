require 'slack-notifier'
class SlackClient
  def initialize
    @notifier = Slack::Notifier.new ENV["SLACK_WEBHOOK_URL"],
      channel: ENV["SLACK_DEFAULT_CHANNEL"],
      username: 'bot',
      icon_emoji: ":robot_face:"
  end

  def send_message(message, channel = ENV["SLACK_DEFAULT_CHANNEL"])
    @notifier.ping message, channel: channel
  end
end