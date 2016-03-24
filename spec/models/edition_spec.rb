require 'rails_helper'

RSpec.describe Edition, type: :model do

  context 'creation' do

    before :example do
      @year = Forgery(:date).year(past: true, max_delta: 10, min_delta: 2)
      @start_date = Time.new(@year) + Forgery(:basic).number(at_least: 250, at_most: 310).days
      @end_date   = @start_date + Forgery(:basic).number(at_least: 4, at_most: 15).days
      @submission_deadline = @start_date - 5.months
      Edition.where('current = ?', :false).destroy_all
    end

    let(:valid_attributes) {
      HashWithIndifferentAccess.new(year: @year, title: Forgery(:emuform).title, start_date: @start_date, end_date: @end_date,
                                    description_en: Forgery(:lorem_ipsum).sentences(5),
                                    description_it: Forgery(:lorem_ipsum).sentences(5),
                                    submission_deadline: @submission_deadline,
      )
    }

    it 'always has a current edition' do
      expect(Edition.current.valid?).to be(true)
    end
  
    it 'cannot be created through the usual constructors' do
      expect { Edition.new }.to raise_error(NoMethodError)
      expect { Edition.create }.to raise_error(NoMethodError)
      expect { Edition.create! }.to raise_error(NoMethodError)
    end

    it 'can only be created through the +switch+ method' do
      expect((cy = Edition.current.year).kind_of?(Numeric)).to be(true)
      expect((e = Edition.switch!(valid_attributes)).valid?).to be(true)
      expect(Edition.current).to eq(e)
      expect(Edition.current.year).not_to eq(cy)
    end

    it 'can return all past editions if requested to' do
      num_editions = 10
      expect((past_editions = FactoryGirl.create_list(:old_edition_without_switch, num_editions)).class).to be(Array)
      expect(Edition.count).to eq(num_editions + 1)
      expect(Edition.past.count).to eq(num_editions)
    end

  end

end
