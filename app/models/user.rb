class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  validates_presence_of :name

  def slack_channel
    "@#{slack_username}"
  end
end
