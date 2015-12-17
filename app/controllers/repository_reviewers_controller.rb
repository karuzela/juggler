class RepositoryReviewersController < AuthenticatedController
  before_action :load_repository

  def update
    @repository.update(authorized_reviewer_ids: params[:reviewer_ids])
    redirect_to @repository, notice: 'Updated authorized reviewers'
  end

  private

  def load_repository
    @repository = Repository.find(params[:id])
  end
end
