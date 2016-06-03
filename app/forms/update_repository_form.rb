class UpdateRepositoryForm
  include ActiveModel::Model

  attr_accessor(
    :claim_time, :remind_time, :authorized_reviewer_ids
  )

  def initialize(repository_attrs, form_attributes = {})
    super repository_attrs.merge(form_attributes)
  end

  validates :claim_time, :remind_time, numericality: { greater_than: 0 }

  def attributes
    {
      claim_time: claim_time,
      remind_time:remind_time,
      authorized_reviewer_ids: authorized_reviewer_ids
    }
  end
end
