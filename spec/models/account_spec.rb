require 'rails_helper'

RSpec.describe Account, type: :model do

  #
  # +Account+ is a devise model, and as such all devise authentication
  # internals are already tested in the devise model itself.
  #
  # So we test everything else, the non-devise part
  #
  context 'associations' do

    it 'can add works as it pleases to' do
      na = 2
      nr = 3
      expect((account = FactoryGirl.create(:account)).valid?).to be(true)
      expect((work = FactoryGirl.create(:work_with_authors_and_roles, num_authors: na, num_roles: nr)).valid?).to be(true)

      account.works << work

      expect(account.works(true).uniq.count).to eq(1)
      expect(account.works.first.authors(true).uniq.count).to eq(na)
      account.works.uniq.first.authors.uniq.each { |a| expect(a.roles.uniq.count).to eq(nr) }
    end

  end

end
