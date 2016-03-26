class ApplicationMailer < ActionMailer::Base
  default from: "submissions-no_reply@emufest.org"
  layout 'mailer'
end
