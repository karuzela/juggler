class SlackAttachmentBuilder
  def self.build(pull_request)
    return {
      author_name: "Juggler",
      author_link: "http://#{ENV['ACTION_MAILER_HOST']}",
      author_icon: "http://#{ENV['ACTION_MAILER_HOST']}/img/juggler-icon.png",
      color: "#7CD197",
      title: pull_request.title,
      title_link: pull_request.url,
      text: pull_request.body,
      fallback: pull_request.title,
      thumb_url: "http://#{ENV['ACTION_MAILER_HOST']}/img/pull-request-icon.png",
      fields: [
        {
          title: "Repository",
          value: "<#{pull_request.repository.html_url}|#{pull_request.repository.full_name}>",
          short: true
        },
        {
          title: "Number",
          value: pull_request.issue_number,
          short: true
        },
        {
          title: "Claim command",
          value: "juggler:claim " + pull_request.token,
          short: true
        }
      ]
    }
  end
end
