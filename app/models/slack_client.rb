require 'slack-notifier'
class SlackClient
  def initialize
    @notifier = Slack::Notifier.new "https://hooks.slack.com/services/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",
      channel: '#collective-review',
      username: 'bot',
      icon_emoji: ":robot_face:"
  end

  def send_message(message, channel = '#collective-review')
    @notifier.ping message, channel: channel
  end
end