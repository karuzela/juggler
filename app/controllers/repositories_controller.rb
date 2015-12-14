class RepositoriesController < ApplicationController
  before_action :load_repository, only: [:add, :remove]
  protect_from_forgery except: :github_callback

  def index
    @synchronized_repositories = Repository.where(synchronized: true).order(name: :asc)
    @not_synchronized_repositories = Repository.where(synchronized: false).order(name: :asc)
    @repositories = Repository.order(synchronized: :desc).order(name: :asc)
  end

  def add
    if SynchronizeGithubRepositoryService.new(@repository, ENV['GITHUB_ACCESS_TOKEN'], github_callback_repositories_url).call
      redirect_to repositories_path, notice: 'Repository was synchronized'
    else
      redirect_to repositories_path, alert: 'Error. Repository not synchronized. Check your permissions.'
    end
   end

  def remove
    if UnsynchronizeGithubRepositoryService.new(@repository, ENV['GITHUB_ACCESS_TOKEN'], github_callback_repositories_url).call
      redirect_to repositories_path, notice: 'Repository was unsynchronized'
    else
      redirect_to repositories_path, alert: 'Error. Check your permissions.'
    end
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
