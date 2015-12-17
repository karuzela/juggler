class GithubRepositoryService
  def initialize(repo, access_token, callback, opts={})
    @client = Octokit::Client.new(access_token: access_token)
    @repo = repo
    @callback = callback
  end
  
  private

  def topics
    Repository.subscribed_events.collect { |x| @repo.html_url + '/events/' + x.to_s }
  end
end