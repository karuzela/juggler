describe UpdateRepositoryService do
  it 'calls' do
    user = create :user
    repository = create(
      :repository,
      claim_time: 3,
      remind_time: 3,
      authorized_reviewer_ids: [user.id]
    )

    form = double(
      valid?: true,
      attributes: {
        claim_time: 4,
        remind_time: 2,
        authorized_reviewer_ids: []
      }
    )

    service = UpdateRepositoryService.new(form, repository)
    expect(service.call).to eq(true)
    expect(repository.reload.claim_time).to eq 4
    expect(repository.reload.remind_time).to eq 2
    expect(repository.reload.authorized_reviewer_ids).to eq []
  end

  context 'form invalid' do
    it 'returns false' do
      repository = create(:repository, claim_time: 3,)
      form = double(
        valid?: false,
        attributes: {
          claim_time: 4
        }
      )

      service = UpdateRepositoryService.new(form, repository)
      expect(service.call).to eq(false)
      expect(repository.reload.claim_time).to eq 3
    end
  end
end
