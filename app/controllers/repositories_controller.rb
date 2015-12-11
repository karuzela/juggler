class RepositoriesController < ApplicationController

  before_action :set_repository, only: [:add, :remove]

  def index
    @repositories = Repository.order(name: :asc).all
  end

  def add
    SynchronizeGithubRepositoryService.new(@repository, ENV['GITHUB_ACCESS_TOKEN'], repositories_url).call
    redirect_to repositories_path, notice: 'Repository was synchronized'
  end

  def remove
    UnsynchronizeGithubRepositoryService.new(@repository, ENV['GITHUB_ACCESS_TOKEN'], repositories_url).call
    redirect_to repositories_path, notice: 'Repository was unsynchronized'
  end

  def refresh
    GetGithubRepositoriesListService.new(ENV['GITHUB_ACCESS_TOKEN']).call
    redirect_to repositories_path, notice: 'Repositories list was refreshed'
  end

  private

  def set_repository
    @repository = Repository.find(params[:id])
  end
end
