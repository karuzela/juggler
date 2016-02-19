class ProcessPullRequestFromPayloadService
  def initialize(payload, opts={})
    @payload = payload
  end

  def call
    @pull_request = PullRequest.find_by_github_id(@payload['pull_request']['id'])
    if pr_opened?
      process_opened_pr
    elsif pr_closed?
      process_closed_pr
    end
    update_pr
  end

  private

  def pr_opened?
    ['opened', 'reopened', 'synchronize'].include? @payload['action']
  end

  def pr_closed?
    @payload['action'] == 'closed'
  end

  def payload_newer_than_pr?
    if @pull_request.head_sha == @payload['pull_request']['head']['sha'] && !@new_record
      false
    else
      true
    end
  end

  def update_pr
    p 'UPDATE'
    @pull_request.update(
      body: @payload['pull_request']['body'],
      head_sha: @payload['pull_request']['head']['sha'],
      title: @payload['pull_request']['title']
    )
  end

  def process_opened_pr
    if @pull_request.nil?
      @pull_request = PullRequest.create(pr_params(@payload))
      @new_record = true
    else
      @pull_request.update_attribute :state, PullRequestState::PENDING
      @new_record = false
    end
    status = @pull_request.reviewer ? PullRequestState::PENDING : 'unassigned'
    SendStatusToGithubPullRequest.new(@pull_request, status).call
    if payload_newer_than_pr?
      send_slack_info_message
      send_email_to_reviewer
    end
  end

  def process_closed_pr
    return if @pull_request.nil?
    new_state = @payload['pull_request']['merged'] ? 'merged' : 'closed'
    @pull_request.update_attribute :state, new_state
  end

  def set_token
    token = SecureRandom.hex(3)
    while PullRequest.where(token: token).present?
      token = SecureRandom.hex(3)
    end
    token
  end

  def pr_params(payload)
    pr_hash = {}

    pr_hash[:state] = PullRequestState::PENDING
    pr_hash[:github_id] = payload['pull_request']['id']
    pr_hash[:opened_at] = payload['pull_request']['created_at']
    pr_hash[:title] = payload['pull_request']['title']
    pr_hash[:body] = payload['pull_request']['body']
    pr_hash[:issue_number] = payload['pull_request']['number']
    pr_hash[:repository_id] = Repository.find_by_github_id(payload['repository']['id']).id
    pr_hash[:url] = payload['pull_request']['html_url']
    pr_hash[:token] = set_token

    return pr_hash
  end

  def send_slack_info_message
    if @pull_request.reviewer
      SendSlackMessageService.new(@pull_request, :pr_updated).call
      ReminderWorker.perform_at(WorkingHoursChecker.new(delay: ENV["REMAIND_AFTER_HOURS"]).get_date, @pull_request.id)
    else
      SendSlackMessageService.new(@pull_request, :new_pr).call
    end
  end

  def send_email_to_reviewer
    return unless @pull_request.reviewer
    NotificationMailer.back_to_review(@pull_request).deliver_now
  end
end
