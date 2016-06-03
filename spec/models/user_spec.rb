require 'rails_helper'

describe User do
  describe 'connected with github' do
    it 'should return false if some of required data is missing' do
      user1 = create(:user, github_id: 1)
      user2 = create(:user, github_access_token: 'token')
      user3 = create(:user)
      expect(user1.connected_with_github?).to be false
      expect(user2.connected_with_github?).to be false
      expect(user3.connected_with_github?).to be false
    end

    it 'should return true if required data is present' do
      user = create(:user, github_id: 1, github_access_token: 'token')
      expect(user.connected_with_github?).to be true
    end
  end

  describe 'slack_channel' do
    it 'should return nil if slack_username is empty' do
      user = create(:user, slack_username: nil)
      expect(user.slack_channel).to be_nil
    end

    it 'should return valid slack_username' do
      user = create(:user, slack_username: 'test')
      expect(user.slack_channel).to eq('@test')
    end
  end
end
