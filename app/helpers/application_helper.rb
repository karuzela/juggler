module ApplicationHelper
  def link_to_github_connect(opts={})
    gh_params = {
      client_id: ENV['GITHUB_APP_CLIENT_ID'],
      redirect_uri: github_connect_users_url,
      scope: 'repo'
    }
    url = 'https://github.com/login/oauth/authorize?' + gh_params.to_query

    if current_user.connected_with_github?
      link_to '#', opts do
        '<i class="fa fa-github"></i> Connected'.html_safe
      end
    else
      link_to url, opts do
        '<i class="fa fa-github"></i> Connect with Github'.html_safe
      end
    end
  end

  def github_avatar(user, img_size=20)
    if user.github_id.present?
      image_tag('https://avatars.githubusercontent.com/u/' + user.github_id.to_s, width: img_size, class: 'github-avatar')
    else
      ''
    end
  end
end