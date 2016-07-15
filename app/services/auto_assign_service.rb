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
    SendSlackMessageService.new(@pull_request, :auto_assign).call
  end

  def set_remainder
    return unless @reviewer
    ReminderWorker.perform_at(WorkingHoursChecker.new(delay: ENV["REMAIND_AFTER_HOURS"]).get_date, @pull_request.id)
  end
end
