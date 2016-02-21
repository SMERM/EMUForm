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

    it 'can be built and saved with complete work/role relationships' do
      work = FactoryGirl.create(:work_with_authors_and_roles) # work can also have *other* authors and roles
      vps = valid_parameters.dup
      vps.update(roles_attributes: [ {id: 1}, {id: 2}, {id: 3} ], work_id: work.to_param)
      (a, ras) = Author.build(vps)
      expect(a.valid?).to be(true)
      expect(a.new_record?).to be(true)
      expect(a.save_with_work(work, ras)).to be(true)
      expect(a.works(true).uniq.count).to eq(1)
      expect(a.roles(true).uniq.count).to eq(3)
    end
     
  end

end
