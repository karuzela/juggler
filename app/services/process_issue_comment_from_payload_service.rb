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
    if comment.include? GH_ACCEPT_STRING
      p 'FROM GH: ACCEPT'
      @pull_request.update_attribute :state, PullRequestState::ACCEPTED
    elsif comment.include? GH_REJECT_STRING
      p 'FROM GH: REJECT'
    elsif comment.include? GH_CLAIM_STRING
      p 'FROM GH: CLAIM'
    end
  end

end