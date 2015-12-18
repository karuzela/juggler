describe AcceptPullRequestService do
  let(:pull_request) { create(:pull_request) }

  it 'change state' do
    service = AcceptPullRequestService.new(pull_request)
    expect{ service.call }.to change(pull_request, :state).from(PullRequestState::PENDING).to(PullRequestState::ACCEPTED)
  end
end
