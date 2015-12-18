class GithubIntegrationController < AuthenticatedController
  def synchronize_repositories
    GetGithubRepositoriesListService.new(ENV['GITHUB_ACCESS_TOKEN']).call
    redirect_to repositories_path, notice: 'Repositories list was refreshed'
  end

  def synchronize_webhooks
    errors = []
    Repository.where(synchronized: true).each do |repo|
      result = SynchronizeGithubRepositoryService.new(repo, ENV['GITHUB_ACCESS_TOKEN'], webhook_url).call
      errors.push(repo.full_name) unless result
    end

    if errors.empty?
      flash[:notice] = 'Webhooks were refreshed.'
    else
      flash[:notice] = "Those repositories were not refreshed: #{errors.to_sentence}. Please do it manually."
    end

    redirect_to repositories_path
  end
end
