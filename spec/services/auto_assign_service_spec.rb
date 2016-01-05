require 'rails_helper'

describe AutoAssignService do
  let(:pr) { create(:pull_request) }
  let!(:user) { create(:user) }

  before do
    allow_any_instance_of(SlackClient).to receive_messages(send_message: true)
    create(:repository_reviewer, repository: pr.repository, user: user)
  end

  it 'set user with lower repository to review' do
    user_2 = create(:user)
    user_3 = create(:user)
    create(:pull_request, reviewer: user_2)
    create(:pull_request, reviewer: user_3)
    create(:pull_request, reviewer: user_3)
    create(:repository_reviewer, repository: pr.repository, user: user_2)
    create(:repository_reviewer, repository: pr.repository, user: user_3)

    service = AutoAssignService.new(pr)
    expect{ service.call }.to change(pr, :reviewer).from(nil).to(user)
  end

  it 'send email' do
    service = AutoAssignService.new(pr)
    expect { service.call }.to change { ActionMailer::Base.deliveries.count }.by(2) #also from worker
  end
end