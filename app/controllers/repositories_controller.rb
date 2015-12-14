class RepositoriesController < ApplicationController
  before_action :load_repository, only: [:add, :remove, :show, :authorized_reviewers]
  protect_from_forgery except: :github_callback

  def index
    @synchronized_repositories = Repository.where(synchronized: true).order(name: :asc)
    @not_synchronized_repositories = Repository.where(synchronized: false).order(name: :asc)
    @repositories = Repository.order(synchronized: :desc).order(name: :asc)
  end

  def show
    @users = User.order(:name)
  end

  def authorized_reviewers
    @repository.update(authorized_reviewer_ids: params[:reviewer_ids])
    redirect_to @repository, notice: 'Updated authorized reviewers'
  end

  def add
    SynchronizeGithubRepositoryService.new(@repository, ENV['GITHUB_ACCESS_TOKEN'], github_callback_repositories_url).call
    redirect_to repositories_path, notice: 'Repository was synchronized'
  end

  def remove
    UnsynchronizeGithubRepositoryService.new(@repository, ENV['GITHUB_ACCESS_TOKEN'], github_callback_repositories_url).call
    redirect_to repositories_path, notice: 'Repository was unsynchronized'
  end

  def refresh
    GetGithubRepositoriesListService.new(ENV['GITHUB_ACCESS_TOKEN']).call
    redirect_to repositories_path, notice: 'Repositories list was refreshed'
  end

  def github_callback
    payload = JSON.parse params[:payload]
    CreatePullRequestFromPayloadService.new(payload).call
    head :ok, content_type: "text/html"
  end

  private

  def load_repository
    @repository = Repository.find(params[:id])
  end
end
