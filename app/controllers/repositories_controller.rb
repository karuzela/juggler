class RepositoriesController < AuthenticatedController
  before_action :load_repository, only: [:add, :remove, :show, :update, :destroy]

  def index
    @synchronized_repositories = Repository.where(synchronized: true).order(full_name: :asc)
    @not_synchronized_repositories = Repository.where(synchronized: false).order(full_name: :asc)
  end

  def show
    @users = User.order(:name)
  end

  def new
    @repository = Repository.new
    @required_scopes = Repository.subscribed_events
  end

  def create
    @repository = Repository.new(repo_params)
    @required_scopes = Repository.subscribed_events
    if @repository.save
      redirect_to repositories_path, notice: 'Repository saved. Please add webhook in Github repository settings panel'
    else
      render :new
    end
  end

  def update
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

  def repo_params
    params.require(:repository).permit(:full_name, :github_id)
  end

  def load_repository
    @repository = Repository.find(params[:id])
  end
end
