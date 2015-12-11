class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAIL_SMTP_SETTINGS_FROM']
end
