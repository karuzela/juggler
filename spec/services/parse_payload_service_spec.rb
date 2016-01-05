require 'rails_helper'

describe ParsePayloadService do

  it 'call pull requests processing service' do
    allow(ProcessPullRequestFromPayloadService).to receive(:new).and_return(service = double("service", call: true))
    expect(service).to receive(:call)
    ParsePayloadService.new({'pull_request' => 1}).call
  end

  it 'call issue comment processing service' do
    allow(ProcessIssueCommentFromPayloadService).to receive(:new).and_return(service = double("service", call: true))
    expect(service).to receive(:call)
    ParsePayloadService.new({'comment' => 1}).call
  end

  it 'call new webhook processing service' do
    allow(ProcessNewWebhookFromPayloadService).to receive(:new).and_return(service = double("service", call: true))
    expect(service).to receive(:call)
    ParsePayloadService.new({'zen' => 1, 'repository' => 1}).call
  end
end