require 'rails_helper'

describe ConnectWithGithubService do
  let(:user) { create(:user, github_access_token: nil, github_id: nil) }
  let(:code) { 'aaa' }
  let(:access_token) { 'e72e16c7e42f292c6912e7710c838347ae178b4a' }
  let(:service) { ConnectWithGithubService.new(user, code) }

  before(:each) do
    stub_request(:post, 'https://github.com/login/oauth/access_token').to_return(
      status: 200, 
      body: "{\"access_token\":\"#{access_token}\", \"scope\":\"repo,gist\", \"token_type\":\"bearer\"}"
    )
    stub_request(:get, 'https://api.github.com/user').to_return(status: 200)
  end

  context 'when user logged in' do
    before(:each) do
      allow(Octokit::Client).to receive_message_chain('new.user.id') { '1' }
    end

    it 'update user github_access_token' do
      expect { service.call }.to change(user, :github_access_token).to(access_token)
    end

    it 'update user github_id' do
      expect { service.call }.to change(user, :github_id).to(1)
    end

    it 'return valid token' do
      expect(service.call).to eq('e72e16c7e42f292c6912e7710c838347ae178b4a') 
    end
  end

  context 'when user is not logged in' do
    before(:each) do
      allow(Octokit::Client).to receive_message_chain('new.user.id').and_raise(Octokit::Unauthorized)
    end

    it 'user github_access_token' do
      expect { service.call }.to_not change(user, :github_access_token)
    end

    it 'user github_id' do
      expect { service.call }.to_not change(user, :github_id)
    end

    it 'return nil' do
      expect(service.call).to be_nil
    end
  end
end