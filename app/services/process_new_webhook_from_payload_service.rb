class ProcessNewWebhookFromPayloadService
  def initialize(payload)
    @payload = payload
    @repository = find_repository_by_id_or_full_name
  end

  def call
    return unless @repository

    repo = @payload['repository']
    @repository.update(
      owner: repo['owner']['login'],
      name: repo['name'],
      full_name: repo['full_name'],
      github_id: repo['id'],
      git_url: repo['git_url'],
      html_url: repo['html_url'],
      synchronized: true
    )
  end

  private

  def find_repository_by_id_or_full_name
    Repository.find_by_github_id(@payload['repository']['id']) || 
      Repository.find_by_full_name(@payload['repository']['full_name'])
  end
end