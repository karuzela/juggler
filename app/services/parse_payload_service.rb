class ParsePayloadService

  def initialize(payload)
    @payload = payload
  end

  def call
    if @payload['pull_request'].present?
      ProcessPullRequestFromPayloadService.new(@payload).call
    elsif @payload['issue'].present?
      ProcessIssueCommentFromPayloadService.new(@payload).call
    end
  end

end