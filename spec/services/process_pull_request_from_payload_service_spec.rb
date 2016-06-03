require 'rails_helper'

describe ProcessPullRequestFromPayloadService do
  let!(:repository) { create(:repository, github_id: 1) }

  before do 
    allow(SendStatusToGithubPullRequest).to receive_message_chain('new.call')
    stub_request(:post, /.*hooks.slack.com*/).to_return(status: 200)
  end

  context 'when opened payload received' do
    let(:opened_payload) { JSON.parse( File.open(Rails.root.to_s + '/spec/fixtures/pull_request_opened_payload.json').read ) }
    let(:service) { ProcessPullRequestFromPayloadService.new(opened_payload) }

    it 'creates new pull request if not found' do
      expect { service.call }.to change { PullRequest.all.count }.by(1)
    end

    it 'updates rejected PR state to pending' do
      pr = create(:pull_request, github_id: 1, id: 1, state: PullRequestState::REJECTED)
      expect { service.call }.to change { pr.reload.state }.from(PullRequestState::REJECTED).to(PullRequestState::PENDING)
    end

    it 'sends slack message' do
      create(:pull_request, github_id: 1, id: 1, state: PullRequestState::PENDING)
      expect(SlackClient).to receive_message_chain('new.send_message')
      service.call
    end
  end

  context 'when closed payload received' do
    let(:closed_payload) { JSON.parse( File.open(Rails.root.to_s + '/spec/fixtures/pull_request_closed_payload.json').read ) }
    let(:service) { ProcessPullRequestFromPayloadService.new(closed_payload) }

    it 'updates status to closed if merge flag is false' do
      pr = create(:pull_request, github_id: 1, id: 1, state: PullRequestState::PENDING)
      expect { service.call }.to change { pr.reload.state }.from(PullRequestState::PENDING).to(PullRequestState::CLOSED)
    end

    it 'updates status to merged if merge flag is true' do
      pr = create(:pull_request, github_id: 1, id: 1, state: PullRequestState::PENDING)
      closed_payload['pull_request']['merged'] = true
      expect { service.call }.to change { pr.reload.state }.from(PullRequestState::PENDING).to(PullRequestState::MERGED)
    end
  end
end
