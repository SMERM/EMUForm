# Preview all emails at http://localhost:3000/rails/mailers/submission_confirmation
class SubmissionConfirmationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/submission_confirmation/confirm
  def confirm
    account = FactoryGirl.create(:account)
    work = FactoryGirl.create(:work_with_authors_roles_and_submitted_files, owner_id: account.to_param)
    SubmissionConfirmation.confirm(work)
  end

end
