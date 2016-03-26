require 'rails_helper'

RSpec.describe Category, type: :model do

  context 'creation' do

    before :example do
      @num_default_categories = 3
    end

    let(:valid_attributes) {
      HashWithIndifferentAccess.new(acro: Forgery(:basic).text(exactly: 4).upcase,
                                    title_en: Forgery(:lorem_ipsum).sentence,
                                    title_it: Forgery(:lorem_ipsum).sentence,
                                    description_en: Forgery(:lorem_ipsum).sentences(2),
                                    description_it: Forgery(:lorem_ipsum).sentences(2),
      )
    }

    let(:mandatory_attributes) { [ :acro, :title_en, :title_it, :description_en, :description_it ] }

    it 'has three categories by default' do
      expect(Category.count).to eq(@num_default_categories)
    end
  
    it 'can be created using the usual constructors' do
      expect((c = Category.create(valid_attributes)).valid?).to be(true)
    end

    it 'can be created using the factory' do
      expect((c = FactoryGirl.create(:category)).valid?).to be(true)
    end

    it 'must have unique acros' do
      expect((c = Category.create(valid_attributes)).valid?).to be(true)
      expect((c2 = Category.new(valid_attributes)).valid?).to be(false)
      expect(c2.errors.full_messages.join(', ')).to eq('Acro has already been taken')
    end

    it 'must have all the attributes required' do
      mandatory_attributes.each do
        |attr|
        args = valid_attributes.deep_dup
        args.delete(attr)
        expect((c = Category.new(args)).valid?).to be(false)
        expect(c.errors.full_messages.join(', ')).to eq("#{attr.to_s.capitalize.humanize} can't be blank")
      end
    end

    it 'has a full_title method' do
      expect((c = FactoryGirl.create(:category)).respond_to?(:full_title)).to be(true)
      expect(c.full_title).to eq([c.acro, c.title_en].join(': '))
    end

  end

end
