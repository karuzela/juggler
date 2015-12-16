class ProcessIssueCommentFromPayloadService

  GH_ACCEPT_STRING = 'juggler:accept'
  GH_REJECT_STRING = 'juggler:reject'
  GH_CLAIM_STRING = 'juggler:claim'

  def initialize(payload)
    @payload = payload
  end

  def call
    repo = Repository.find_by_github_id(@payload['repository']['id'])
    @pull_request = repo.pull_requests.find_by_issue_number(@payload['issue']['number'])
    analyze_comment(@payload['comment']['body'])
  end

  def analyze_comment(comment)
    comment = comment.downcase
    if comment.include? GH_ACCEPT_STRING
      accept_pr  
    elsif comment.include? GH_REJECT_STRING
      reject_pr
    elsif comment.include? GH_CLAIM_STRING
      claim_pr
    end
  end

  def accept_pr
    if @pull_request.pending?
      @pull_request.update_attribute :state, PullRequestState::ACCEPTED
    end
  end

  def reject_pr
    if @pull_request.pending?
      @pull_request.update_attribute :state, PullRequestState::REJECTED
    end
  end

  def claim_pr
    user = User.find_by_github_id(@payload['sender']['id'])
    if @pull_request.reviewer.blank? and user.present?
      @pull_request.update(reviewer: user)
    end
  end

end