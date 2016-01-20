require 'rails_helper'

RSpec.describe Author, type: :model do
  
  let(:valid_parameters) {
    {
      :first_name => Forgery(:name).female_first_name, :last_name => Forgery(:name).last_name,
      :birth_year => Forgery(:basic).number(:at_least => Time.zone.now.year - 200, :at_most => Time.zone.now.year - 15).to_s,
      :bio_en => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
      :bio_it => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 10)),
    }
  }

  let(:mandatory_parameters) {
    [:first_name, :last_name]
  }

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
      expect(FactoryGirl.create(:author).valid?).to be(true)
    end
     
  end

  context 'associations' do

    it 'can link works as a single author' do
      num_works = 3
      expect((a = FactoryGirl.create(:author)).valid?).to be(true)
      expect((ws = FactoryGirl.create_list(:work, num_works)).class).to be(Array)
      a.works << ws
      expect(a.works(true).count).to eq(num_works)
    end

    it 'can link works through multiple authors' do
      num_works = 3
      num_authors = 5
      expect((as = FactoryGirl.create_list(:author, num_authors)).class).to be(Array)
      expect((ws = FactoryGirl.create_list(:work, num_works)).class).to be(Array)
      as.each { |a| a.works << ws }
      as.each { |a| expect(a.works(true).count).to eq(num_works) }
      ws.each { |w| expect(w.authors(true).count).to eq(num_authors) }
    end

  end

  context 'object destruction' do

    it 'actually destroys the links with the work when destroyed' do
      num_works = 3
      expect((a = FactoryGirl.create(:author)).valid?).to be(true)
      expect((ws = FactoryGirl.create_list(:work, num_works)).size).to eq(num_works)
      a.works << ws
      expect(a.works(true).count).to eq(num_works)
      #
      a.destroy
      expect(a.frozen?).to be(true)
      ws.each { |w| expect(w.frozen?).to be(false) }
      ws.each { |w| expect(w.authors(true).count).to eq(0) } # check that intermediate records are destroyed
    end

  end

end
