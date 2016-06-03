require 'rails_helper'

describe SendSlackMessageService do
  let(:reviewer) { create(:user) }
  let(:pull_request) { create(:pull_request, reviewer: reviewer) }
  let(:service) { SendSlackMessageService.new(pull_request, message_type) }
  let(:url) { Rails.application.routes.url_helpers.pull_request_url(pull_request, host: ENV["ACTION_MAILER_HOST"]) }
  let(:default_channel) { ENV["SLACK_DEFAULT_CHANNEL"] }

  context "message type is set to new_pr" do
    let(:message_type) { :new_pr }

    it "should send valid message" do
      expect(service.send(:message)).to eq(
        "Greetings *Visuality Team*. New pull request is ready for code review. To claim it [click here](#{url}) or type \`juggler:claim #{pull_request.token}\` on this channel."
      )
    end

    it "should send message to default channel" do
      expect(service.send(:channel)).to eq(default_channel)
    end
  end

  context "message type is set to reminder" do
    let(:message_type) { :reminder }

    it "should send valid message" do
      expect(service.send(:message)).to eq(
        "Hey! Remember to review this pull request. Do not test my patience. [Details are here](#{url})"
      )
    end

    it "should send message to reviewer" do
      expect(service.send(:channel)).to eq(reviewer.slack_channel)
    end
  end

  context "message type is set to auto_assign" do
    let(:message_type) { :auto_assign }

    it "should send valid message" do
      expect(service.send(:message)).to eq(
        "Hey! You were auto-assigned to review this pull request. [Click here for details](#{url})"
      )
    end

    it "should send message to reviewer" do
      expect(service.send(:channel)).to eq(reviewer.slack_channel)
    end
  end

  context "message type is set to pr_updated" do
    let(:message_type) { :pr_updated }

    it "should send valid message" do
      expect(service.send(:message)).to eq(
        "Hey! This pull request was updated. [Click here for details](#{url})"
      )
    end

    it "should send message to reviewer" do
      expect(service.send(:channel)).to eq(reviewer.slack_channel)
    end
  end
end
