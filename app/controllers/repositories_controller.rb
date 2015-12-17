class RepositoriesController < AuthenticatedController
  before_action :load_repository, only: [:add, :remove, :show, :authorized_reviewers, :destroy]

  def index
    @synchronized_repositories = Repository.where(synchronized: true).order(full_name: :asc)
    @not_synchronized_repositories = Repository.where(synchronized: false).order(full_name: :asc)
  end

  def show
    @users = User.order(:name)
  end

  def authorized_reviewers
    @repository.update(authorized_reviewer_ids: params[:reviewer_ids])
    redirect_to @repository, notice: 'Updated authorized reviewers'
  end

  def add
    if SynchronizeGithubRepositoryService.new(@repository, ENV['GITHUB_ACCESS_TOKEN'], webhook_url).call
      redirect_to repositories_path, notice: 'Repository was synchronized'
    else
      redirect_to repositories_path, alert: 'Error. Repository not synchronized. Check your permissions.'
    end
  end

  def remove
    if UnsynchronizeGithubRepositoryService.new(@repository, ENV['GITHUB_ACCESS_TOKEN'], webhook_url).call
      redirect_to repositories_path, notice: 'Repository was unsynchronized'
    else
      redirect_to repositories_path, alert: 'Error. Check your permissions.'
    end
  end

  def destroy
    @repository.destroy
    redirect_to repositories_path, notice: "Repository removed"
  end

  private

  def load_repository
    @repository = Repository.find(params[:id])
  end
end
