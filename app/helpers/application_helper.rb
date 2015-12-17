module ApplicationHelper
  def link_to_github_connect
    gh_params = {
      client_id: ENV['GITHUB_APP_CLIENT_ID'],
      redirect_uri: github_connect_users_url,
      scope: 'repo'
    }
    url = 'https://github.com/login/oauth/authorize?' + gh_params.to_query

    if current_user.connected_with_github?
      link_to '#' do
        '<i class="fa fa-github"></i> Connected'.html_safe
      end
    else
      link_to(url) do
        '<i class="fa fa-github"></i> Connect with Github'.html_safe
      end
    end
  end
end
