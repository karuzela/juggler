describe ProcessIssueCommentFromPayloadService do
  let(:claim_message) { "Test message juggler:claim" }
  let(:accept_message) { "Test message juggler:accept" }
  let(:reject_message) { "Test message juggler:reject" }
  let!(:repository) { create(:repository, github_id: 1) }
  let!(:pull_request) { create(:pull_request, issue_number: 1, repository: repository) }
  let(:payload) { JSON.parse( File.open(Rails.root.to_s + '/spec/fixtures/issue_comment_payload.json').read ) }
  let(:reviewer) { create(:user, github_id: 1) }
  let(:claim_payload) { 
    cp = payload.dup
    cp['comment']['body'] = claim_message
    cp
  }
  let(:reject_payload) {
    rp = payload.dup
    rp['comment']['body'] = reject_message
    rp
  }
  let(:accept_payload) {
    ap = payload.dup
    ap['comment']['body'] = accept_message
    ap
  }

  before(:each) {
    allow(SendStatusToGithubPullRequest).to receive_message_chain('new.call').and_return(true)
  }

  context 'on accept message payload' do
    before { @service = ProcessIssueCommentFromPayloadService.new(accept_payload) }

    it 'accepts pending pull request' do
      expect { @service.call }.to change { pull_request.reload.state }.from(PullRequestState::PENDING).to(PullRequestState::ACCEPTED)
    end

    it 'accepts rejected pull request' do
      pull_request.update_attribute :state, PullRequestState::REJECTED
      expect { @service.call }.to change { pull_request.reload.state }.from(PullRequestState::REJECTED).to(PullRequestState::ACCEPTED)
    end
  end

  context 'on claim message payload' do
    before { @service = ProcessIssueCommentFromPayloadService.new(claim_payload) }

    it 'claims pull request' do
      expect { @service.call }.to change { pull_request.reload.reviewer }.from(nil).to(reviewer)
    end

    it 'should not claim pull_request (reviewer unknown)' do
      expect { @service.call }.to_not change { pull_request.reload.reviewer }.from(nil)
    end
  end

  context 'on reject message payload' do
    before { @service = ProcessIssueCommentFromPayloadService.new(reject_payload) }

    it 'rejects pending pull request' do
      expect { @service.call }.to change { pull_request.reload.state }.from(PullRequestState::PENDING).to(PullRequestState::REJECTED)
    end

    it 'rejects pending pull request' do
      pull_request.update_attribute :state, PullRequestState::ACCEPTED
      expect { @service.call }.to change { pull_request.reload.state }.from(PullRequestState::ACCEPTED).to(PullRequestState::REJECTED)
    end
  end
end