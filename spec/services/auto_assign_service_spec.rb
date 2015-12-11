describe AutoAssignService do
  let(:pr) { create(:pull_request) }
  let!(:user) { create(:user) }

  before do
    allow_any_instance_of(SlackClient).to receive_messages(send_message: true)
  end

  it 'set random user' do
    service = AutoAssignService.new(pr)
    expect{ service.call }.to change(pr, :reviewer).from(nil).to(user)
  end

  it 'send email' do
    service = AutoAssignService.new(pr)
    expect { service.call }.to change { ActionMailer::Base.deliveries.count }.by(2) #also from worker
  end
end