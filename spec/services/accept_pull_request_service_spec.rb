require 'rails_helper'

describe AcceptPullRequestService do
  let(:pull_request) { create(:pull_request, state: PullRequestState::PENDING) }

  it 'change state' do
    service = AcceptPullRequestService.new(pull_request)
    expect(SendStatusToGithubPullRequest).to receive(:new).and_return(
      github_status_service = double(:send_status_to_github_service)
    )
    expect(github_status_service).to receive(:call).and_return(true)
    expect{ service.call }.to change(pull_request, :state).from(PullRequestState::PENDING).to(PullRequestState::ACCEPTED)
  end
end
