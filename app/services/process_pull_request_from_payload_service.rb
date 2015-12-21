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
      @pull_request.update_attribute :state, 'pending'
      @new_record = false
    end
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

  def pr_params(payload)
    pr_hash = {}

    pr_hash[:state] = 'pending'
    pr_hash[:github_id] = payload['pull_request']['id']
    pr_hash[:opened_at] = payload['pull_request']['created_at']
    pr_hash[:title] = payload['pull_request']['title']
    pr_hash[:body] = payload['pull_request']['body']
    pr_hash[:issue_number] = payload['pull_request']['number']
    pr_hash[:repository_id] = Repository.find_by_github_id(payload['repository']['id']).id
    pr_hash[:url] = payload['pull_request']['html_url']

    return pr_hash
  end

  def send_slack_info_message
    slack = SlackClient.new()
    url = Rails.application.routes.url_helpers.pull_request_url(@pull_request, host: ENV["ACTION_MAILER_HOST"])
    attachments = [SlackAttachmentBuilder.build(@pull_request)]

    if @pull_request.reviewer
      slack.send_message(
        "Hey! This pull request was updated. [Click here for details](#{url})",
        attachments: attachments,
        channel: @pull_request.reviewer.slack_channel
      )
      ReminderWorker.perform_at(WorkingHoursChecker.new(delay: ENV["REMAIND_AFTER_HOURS"]).get_date, @pull_request.id)
    else
      slack.send_message(
        "Greetings *Visuality Team*. New pull request is ready for code review. [Click here to claim it](#{url})",
        attachments: attachments
      )
    end
  end

  def send_email_to_reviewer
    return unless @pull_request.reviewer
    NotificationMailer.back_to_review(@pull_request).deliver_now
  end
end