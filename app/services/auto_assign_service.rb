class AutoAssignService
  def initialize(pull_request)
    @pull_request = pull_request
  end

  def call
    return false if @pull_request.reviewer || !@pull_request.pending?
    update_pull_request
    send_slack_message
    send_email_messsage
    set_remainder

    true
  end

  private
  def update_pull_request
    @pull_request.update(reviewer: User.all.sample)
  end

  def send_slack_message
    slack = SlackClient.new()
    slack.send_message("You are auto assigned to PR review", @pull_request.reviewer.slack_channel)
  end

  def send_email_messsage
    NotificationMailer.auto_assign(@pull_request).deliver_now
  end

  def set_remainder
    ReminderWorker.perform_at(ENV["REMAIND_AFTER_HOURS"].to_i.hours.from_now, @pull_request.id)
  end
end