describe UpdateRepositoryForm do
  it 'valid' do
    repository_attributes = {
      claim_time: 3,
      remind_time: 3,
      authorized_reviewer_ids: []
    }
    repository_form_params = {
      claim_time: 500,
      remind_time: 3,
      authorized_reviewer_ids: [2]
    }

    form = UpdateRepositoryForm.new(
      repository_attributes,
      repository_form_params
    )

    expect(form.valid?).to eq true
    expect(form.claim_time).to eq 500
    expect(form.remind_time).to eq 3
    expect(form.authorized_reviewer_ids).to eq [2]
  end

  context 'claim time < 0' do
    it 'invalid' do
      repository_attributes = {
        claim_time: 3,
        remind_time: 3,
        authorized_reviewer_ids: []
      }
      repository_form_params = {
        claim_time: -3,
        remind_time: 3,
        authorized_reviewer_ids: []
      }

      form = UpdateRepositoryForm.new(
        repository_attributes,
        repository_form_params
      )

      expect(form.valid?).to eq false
    end
  end

  context 'remind time < 0' do
    it 'invalid' do
      repository_attributes = {
        claim_time: 3,
        remind_time: 3,
        authorized_reviewer_ids: []
      }
      repository_form_params = {
        claim_time: 3,
        remind_time: -3,
        authorized_reviewer_ids: []
      }

      form = UpdateRepositoryForm.new(
        repository_attributes,
        repository_form_params
      )

      expect(form.valid?).to eq false
    end
  end
end
