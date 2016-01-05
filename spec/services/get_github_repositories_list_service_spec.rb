require 'rails_helper'

describe GetGithubRepositoriesListService do
  let(:service) { GetGithubRepositoriesListService.new(access_token: 'abcdef') }
  let!(:repository) { create(:repository, github_id: 1) }
  let(:repositories_list) { JSON.parse(File.open(Rails.root.to_s + '/spec/fixtures/github_repositories.json').read) }

  before(:each) do
    allow(Octokit::Client).to receive_message_chain('new.repositories').and_return(repositories_list)
  end

  it 'add 2 new repositories' do
    expect { service.call }.to change { Repository.all.count }.by(2)
  end

  it 'update 1 existing repository' do
    expected_attributes = {
      'full_name' => 'username/repo1',
      'name' => 'repo1',
      'git_url' => 'git@github.com:username/repo1.git',
      'html_url' => 'https://github.com/username/repo1',
      'owner' => 'username'
    }
    expect { service.call }.to change { 
      repository.reload.attributes.slice('full_name', 'name', 'git_url', 'html_url', 'owner') 
    }.to(expected_attributes)
  end
end