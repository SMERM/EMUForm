require 'rails_helper'
require_relative File.join('..', 'support', 'random_roles')

RSpec.describe WorkRoleAuthor, type: :model do

  include RandomRoles

  before :example do
    @owner = FactoryGirl.create(:account)
    @work = FactoryGirl.create(:work, owner_id: @owner.to_param)
    @author = FactoryGirl.create(:author, owner_id: @owner.to_param)
    @role = select_random_roles(1).first
  end

  let(:valid_attributes) {
    HashWithIndifferentAccess.new(work_id: @work.to_param, role_id: @role.to_param, author_id: @author.to_param)
  }

  let(:mandatory_attributes) {
    [:work_id, :role_id, :author_id]
  }

  context 'object creation' do

    it 'does create a WorkRoleAuthor object' do
      expect((wra = WorkRoleAuthor.new(valid_attributes)).class).to be(WorkRoleAuthor)
      expect(wra.errors.any?).to be(false), "it raises the following errors \"#{wra.errors.full_messages.join(', ')}\""
    end

    it 'does full field validation' do
      expect((wra = WorkRoleAuthor.new).class).to be(WorkRoleAuthor)
      expect { wra.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect((wra = WorkRoleAuthor.create!(valid_attributes)).class).to be(WorkRoleAuthor)
      expect(wra.valid?).to be(true)
    end
  
    it 'does individual field validation' do
      expect((wra = WorkRoleAuthor.create(valid_attributes)).valid?).to eq(true)
      #
      # now let's remove a field at a time
      #
      mandatory_attributes.each do
        |field_to_delete|
        inv = valid_attributes.deep_dup
        inv.delete(field_to_delete)
        expect { WorkRoleAuthor.create!(inv) }.to raise_error(ActiveRecord::RecordInvalid), field_to_delete.to_s
      end
    end

    it 'actually connects Work, Role and Author together)' do
      expect((wra = WorkRoleAuthor.create(valid_attributes)).valid?).to be(true)
      expect(@work.authors.uniq.count).to eq(1)
      expect(@work.authors.uniq.first.roles.for_work(@work.to_param).count).to eq(1)
    end

    it 'has a method #exists? that works' do
      expect((wra = WorkRoleAuthor.new(valid_attributes)).valid?).to be(true)
      expect(wra.exists?).to be(false)
      expect(wra.save).to be(true)
      expect(wra.exists?).to be(true)
    end

    it 'cannot be duplicated' do
      exact_same_attributes = valid_attributes.deep_dup
      expect((wra = WorkRoleAuthor.create(exact_same_attributes)).valid?).to be(true)
      expect(wra.exists?).to be(true)
      expect { WorkRoleAuthor.create!(exact_same_attributes) }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

  context 'edition association' do

    it 'associates to the current edition even if it is not mentioned in the actual arguments' do
      expect((wra = WorkRoleAuthor.create(valid_attributes)).valid?).to be(true)
      expect(wra.edition).to eq(Edition.current)
    end

    it 'associates to an older edition if the edition is already set otherwise' do
      expect((old_edition = FactoryGirl.create(:old_edition_without_switch)).valid?).to be(true)
      va = valid_attributes.deep_dup
      va.update(edition_id: old_edition.to_param)
      expect((wra = WorkRoleAuthor.create(va)).valid?).to be(true)
      expect(wra.edition).to eq(old_edition)
    end

  end

end
