class NotyficationMailer < ApplicationMailer

  def auto_assign(pull_request)
    @pull_request = pull_request
    mail to: @pull_request.reviewer, subject: "New pull request to review"
  end
end