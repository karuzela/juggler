class AutoAssignService
  def initialize(pull_request)
    @pull_request = pull_request
  end

  def call
    return false if @pull_request.reviewer || !@pull_request.pending?
    update_pull_request
    send_slack_message
    set_remainder

    true
  end

  private
  def update_pull_request
    @reviewer = @pull_request.repository
      .authorized_reviewers
      .joins("LEFT JOIN pull_requests ON users.id = pull_requests.reviewer_id")
      .select('users.*, count(pull_requests.id) as assigned_count')
      .group('users.id')
      .order('assigned_count asc')
      .first
    @pull_request.update(reviewer: @reviewer)
  end

  def send_slack_message
    return unless @reviewer
    slack = SlackClient.new()
    url = Rails.application.routes.url_helpers.pull_request_url(@pull_request, host: ENV["ACTION_MAILER_HOST"])
    attachments = [SlackAttachmentBuilder.build(@pull_request)]

    slack.send_message(
      "Hey! You were auto-assigned to review this pull request. [Click here for details](#{url})",
      channel: @pull_request.reviewer.slack_channel,
      attachments: attachments
    )
  end

  def set_remainder
    return unless @reviewer
    ReminderWorker.perform_at(WorkingHoursChecker.new(delay: ENV["REMAIND_AFTER_HOURS"]).get_date, @pull_request.id)
  end
end
