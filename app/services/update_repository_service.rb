class UpdateRepositoryService
  def initialize(form, repository)
    @form = form
    @repository = repository
  end

  def call
    return false unless @form.valid?

    update_repository
  end

  private

  def update_repository
    @repository.update_attributes(@form.attributes)
  end
end
