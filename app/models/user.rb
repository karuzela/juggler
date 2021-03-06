class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  validates_presence_of :name

  def slack_channel
    return unless slack_username.present?

    "@#{slack_username}"
  end

  def connected_with_github?
    github_access_token.present? and github_id.present?
  end
end
