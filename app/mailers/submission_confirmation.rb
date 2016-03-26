class SubmissionConfirmation < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.submission_confirmation.confirm.subject
  #
  def confirm(work)
    @work = work

    mail to: @work.owner.email, subject: "[EMUFest #{@work.edition.year}] submission confirmation"
  end
end
