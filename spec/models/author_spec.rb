require 'rails_helper'

RSpec.describe Author, type: :model do
  
  let(:valid_parameters) {
    {
      :first_name => Forgery(:name).female_first_name, :last_name => Forgery(:name).last_name,
      :birth_year => Forgery(:basic).number(:at_least => Time.zone.now.year - 200, :at_most => Time.zone.now.year - 15).to_s,
      :bio_en => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
      :bio_it => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
      :owner_id => @account.to_param,
    }
  }

  let(:mandatory_parameters) {
    [:first_name, :last_name]
  }

  before :example do
    @account = FactoryGirl.create(:account)
    @work = FactoryGirl.create(:work)
  end

  context 'object creation' do

    it 'can be created with valid parameters' do
      parms = valid_parameters.dup
      parms.delete(:birth_year); parms.delete(:bio_en); parms.delete(:bio_it)
      expect((a = Author.create!(parms)).valid?).to be(true)
    end
     
    it 'can be created with all parameters' do
      expect((a = Author.create!(valid_parameters)).valid?).to be(true)
    end
     
    it 'cannot be created if a mandatory parameter is missing' do
      mandatory_parameters.each do
        |mp|
        invalid_parameters = valid_parameters.dup
        invalid_parameters.delete(mp)
        expect((a = Author.create(invalid_parameters)).valid?).to be(false)
        expect(a.errors.any?).to be(true)
          expect(a.errors.full_messages.join(', ')).to eq("#{mp.to_s.humanize} can't be blank")
        end
      end
             
    it 'cannot be created if a mandatory parameter is blank' do
      mandatory_parameters.each do
        |mp|
        invalid_parameters = valid_parameters.dup
        invalid_parameters[mp] = ''
        expect((a = Author.create(invalid_parameters)).valid?).to be(false)
        expect(a.errors.any?).to be(true)
        expect(a.errors.full_messages.join(', ')).to eq("#{mp.to_s.humanize} can't be blank")
      end
    end

    it 'can be created from factory' do
      expect(FactoryGirl.create(:author, owner_id: @account.to_param).valid?).to be(true)
    end

  end

end
