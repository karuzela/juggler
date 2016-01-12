class GetGithubRepositoriesListService
  def initialize(access_token, opts={})
    @client = Octokit::Client.new(access_token: access_token, auto_paginate: true)
  end

  def call
    @client.repositories.each do |r|
      repo = Repository.find_by_github_id(r['id'])
      if repo.nil?
        Repository.create(repository_params_from_api(r))
      else
        repo.update(repository_params_from_api(r))
      end
    end
  end

  private

  def repository_params_from_api(r)
    {
      'github_id' => r['id'],
      'name' => r['name'],
      'full_name' => r['full_name'],
      'git_url' => r['git_url'],
      'html_url' => r['html_url'],
      'owner' => r['owner']['login']
    }
  end
end
