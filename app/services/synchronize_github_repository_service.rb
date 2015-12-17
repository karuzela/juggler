class SynchronizeGithubRepositoryService < GithubRepositoryService
  def call
    topics.each do |topic|
      @client.subscribe(topic, @callback)
    end
    @repo.update_attribute :synchronized, true
  rescue Octokit::UnprocessableEntity => e
    return false
  end
end