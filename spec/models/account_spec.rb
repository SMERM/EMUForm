require 'rails_helper'

RSpec.describe Account, type: :model do

  #
  # +Account+ is a devise model, and as such all devise authentication
  # internals are already tested in the devise model itself.
  #
  # So we test everything else, the non-devise part
  #
  context 'associations' do

    it 'can add author as it pleases to' do
      nw = 2
      expect((account = FactoryGirl.create(:account)).valid?).to be(true)
      expect((author = FactoryGirl.create(:author_with_works, num_works: nw)).valid?).to be(true)

      account << author

      expect(account.authors(true).count).to eq(1)
      expect(account.authors.first.works.uniq.count).to eq(nw)
      account.authors.first.works.uniq.each { |w| expect(w.roles.uniq.count).to be > 0 }
    end

  end

end
