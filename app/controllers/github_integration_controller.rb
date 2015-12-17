class GithubIntegrationController < AuthenticatedController
  def synchronize_repositories
    GetGithubRepositoriesListService.new(ENV['GITHUB_ACCESS_TOKEN']).call
    redirect_to repositories_path, notice: 'Repositories list was refreshed'
  end

  def synchronize_webhooks
    @synchronized_repositories = Repository.where(synchronized: true)
    bugs = []
    @synchronized_repositories.each do |repo|
      result = SynchronizeGithubRepositoryService.new(repo, ENV['GITHUB_ACCESS_TOKEN'], webhook_url).call
      unless result
        bugs.push repo.full_name
      end
    end
    flash[:notice] = 'Webhooks were refreshed.'
    if bugs.present?
      flash[:notice] += "However, those repositories webhooks can not be refreshed: #{bugs.to_sentence}. Please do it manually."
    end
    redirect_to repositories_path
  end
end
