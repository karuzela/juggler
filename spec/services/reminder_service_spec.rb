require 'rails_helper'

describe ReminderService do
  context 'on pending pull request' do
    let(:pull_request) { create(:pull_request, state: PullRequestState::PENDING, reviewer: create(:user)) }
    let(:service) { ReminderService.new(pull_request) }

    before { stub_request(:post, /.*hooks.slack.com*/).to_return(status: 200) }

    it 'sends slack message' do
      expect(SlackClient).to receive_message_chain('new.send_message')
      service.call
    end
  end

  context 'on pull request with state other than pending' do
    let(:closed_pull_request) { create(:pull_request, state: PullRequestState::CLOSED) }
    let(:service) { ReminderService.new(closed_pull_request) }

    it 'returns false' do
      expect(service.call).to be false
    end
  end
end
