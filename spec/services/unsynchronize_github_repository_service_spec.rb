require 'rails_helper'

describe UnsynchronizeGithubRepositoryService do
  let(:repository) { create(:repository, synchronized: true) }
  let(:service) { UnsynchronizeGithubRepositoryService.new(repository, 'token', Rails.application.routes.url_helpers.webhook_path) }

  before do
    allow(Octokit::Client).to receive_message_chain('new.unsubscribe')
  end

  it 'changes synchronized to true' do
    expect { service.call }.to change { repository.synchronized }.from(true).to(false)
  end
end