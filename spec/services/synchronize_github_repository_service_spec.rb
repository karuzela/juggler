describe SynchronizeGithubRepositoryService do
  let(:repository) { create(:repository, synchronized: false) }
  let(:service) { SynchronizeGithubRepositoryService.new(repository, 'token', Rails.application.routes.url_helpers.webhook_path) }

  before do
    allow(Octokit::Client).to receive_message_chain('new.subscribe')
  end

  it 'changes synchronized to true' do
    expect { service.call }.to change { repository.synchronized }.from(false).to(true)
  end
end