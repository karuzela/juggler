class UnsynchronizeGithubRepositoryService < GithubRepositoryService
  def call
    topics.each do |topic|
      @client.unsubscribe(topic, @callback)
    end
    @repo.update_attribute :synchronized, false
  rescue Octokit::UnprocessableEntity => e
    return false
  end
end