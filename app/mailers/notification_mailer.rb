class NotificationMailer < ApplicationMailer

  def auto_assign(pull_request)
    @pull_request = pull_request
    mail to: @pull_request.reviewer, subject: "New pull request to review"
  end

  def reminder(pull_request)
    @pull_request = pull_request
    mail to: @pull_request.reviewer, subject: "Pull request to review"
  end
end