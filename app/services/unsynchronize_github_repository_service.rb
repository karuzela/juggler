class UnsynchronizeGithubRepositoryService

  def initialize(repo, access_token, callback, opts={})
    @client = Octokit::Client.new(access_token: access_token)
    @repo = repo
    @callback = callback
  end

  def call
    @client.unsubscribe(topic, @callback)
    @repo.update_attribute :synchronized, false
  rescue Octokit::UnprocessableEntity => e
    return false
  end

  private

  def topic
    @repo.html_url + '/events/pull_request'
  end

end