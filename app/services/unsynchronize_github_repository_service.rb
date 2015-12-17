class UnsynchronizeGithubRepositoryService
  def initialize(repo, access_token, callback, opts={})
    @client = Octokit::Client.new(access_token: access_token)
    @repo = repo
    @callback = callback
  end

  def call
    topics.each do |topic|
      @client.unsubscribe(topic, @callback)
    end
    @repo.update_attribute :synchronized, false
  rescue Octokit::UnprocessableEntity => e
    return false
  end

  private

  def topics
    Repository.subscribed_events.collect { |x| @repo.html_url + '/events/' + x.to_s }
  end
end