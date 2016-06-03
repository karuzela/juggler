class ReminderService
  def initialize(pull_request)
    @pull_request = pull_request
  end

  def call
    return false unless @pull_request.pending?
    send_slack_message
  end

  private

  def send_slack_message
    SendSlackMessageService.new(@pull_request, :reminder).call
  end
end
