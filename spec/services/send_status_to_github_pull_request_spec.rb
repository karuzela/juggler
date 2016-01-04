describe SendStatusToGithubPullRequest do
  let(:user) { create(:user, email: 'sample@example.com') }
  let(:pull_request) { create(:pull_request, reviewer: user) }
  let(:service) { SendStatusToGithubPullRequest.new(pull_request, 'pending') }
  before do
    allow(Octokit::Client).to receive(:new).and_return( @client = double() )
    allow(@client).to receive_message_chain('pull_request.head.sha').and_return('sha')
  end

  it 'calls send create request to github api' do
    expect(@client).to receive(:create_status)
    service.call
  end

  describe 'get_state_and_description' do
    it 'returns valid values for unassigned' do
      expect( service.send(:get_state_and_description, 'unassigned') ).to eq(
        ['pending', "This pull request is not assigned to any developer."]
      )
    end

    it 'returns valid values for pending' do
      expect( service.send(:get_state_and_description, 'pending') ).to eq(
        ['pending', "This pull request is being reviewed by sample@example.com"]
      )
    end

    it 'returns valid values for accepted' do
      expect( service.send(:get_state_and_description, 'accepted') ).to eq(
        ['success', "Pull request was accepted by sample@example.com"]
      )
    end

    it 'returns valid values for rejected' do
      expect( service.send(:get_state_and_description, 'rejected') ).to eq(
        ['failure', "Pull request was rejected by sample@example.com"]
      )
    end
  end
end