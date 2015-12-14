class NotificationMailer < ApplicationMailer
  def auto_assign(pull_request)
    @pull_request = pull_request
    mail to: @pull_request.reviewer.email, subject: "New pull request to review"
  end

  def reminder(pull_request)
    @pull_request = pull_request
    mail to: @pull_request.reviewer.email, subject: "Pull request to review"
  end

  def back_to_review(pull_request)
    @pull_request = pull_request
    mail to: @pull_request.reviewer.email, subject: "Pull request back review"
  end
end
