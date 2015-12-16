class ConnectWithGithubService

  def initialize(user, code, opts={})
    @user = user
    @code = code
  end

  def call
    gh_params = {
      client_id: ENV['GITHUB_APP_CLIENT_ID'],
      client_secret: ENV['GITHUB_APP_CLIENT_SECRET'],
      code: @code
    }
    response = RestClient.post 'https://github.com/login/oauth/access_token', gh_params, accept: :json
    token = JSON.parse(response.body)['access_token']
    client = Octokit::Client.new(access_token: token)
    @user.update github_access_token: token, github_id: client.user.id
    return token
  rescue => e
    p e
    return nil
  end

end