require "rails_helper"

RSpec.describe SubmissionConfirmation, type: :mailer do

  describe "confirm" do

    before :example do
      @account = FactoryGirl.create(:account)
      @work = FactoryGirl.create(:work_with_authors_roles_and_submitted_files, owner_id: @account.to_param)
    end

    let(:mail) { SubmissionConfirmation.confirm(@work) }

    it "renders the headers" do
      expect(mail.subject).to eq("[EMUFest #{@work.edition.year}] submission confirmation")
      expect(mail.to).to eq([@account.email])
      expect(mail.from).to eq(['submissions-no_reply@emufest.org'])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(Regexp.escape("Dear #{@account.full_name},"))
      [@work.submitted_files.map { |sf| [sf.filename, sf.size] }].flatten.each { |datum| expect(mail.body.encoded).to match(Regexp.escape(datum.to_s)) }
    end
  end

end
