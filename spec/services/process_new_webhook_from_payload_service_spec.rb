require 'rails_helper'

describe ProcessNewWebhookFromPayloadService do
  let(:payload) { JSON.parse( File.open(Rails.root.to_s + '/spec/fixtures/new_webhook_payload.json').read ) }
  let(:service) { ProcessNewWebhookFromPayloadService.new(payload) }

  it 'updates synchronized flag to true' do
    repository = create(:repository, github_id: 1, synchronized: false)
    expect { service.call }.to change { repository.reload.synchronized }.from(false).to(true)
  end

  it 'returns nil if repository is not found in db' do
    expect(service.call).to be_nil
  end
end