require 'rails_helper'

RSpec.describe Work, type: :model do

  let(:args) {
    { :title => 'Test', :year => '2016-01-01', :duration => '0000-01-01 00:03:03', :instruments => 'pno', :program_notes_en => 'test notes', :program_notes_it => 'note di test' }
  }

  it 'does full field validation' do
    expect((w = Work.new).class).to be(Work)
    expect { w.save! }.to raise_error(ActiveRecord::RecordInvalid)
    expect((w = Work.create(args)).class).to be(Work)
  end

  it 'does individual field validation' do
    v_fields = [:title, :year, :duration, :instruments, :program_notes_en]
    expect((w = Work.create(args)).class).to be(Work)
    #
    # now let's remove a field at a time
    #
    v_fields.each do
      |field_to_delete|
      cur_args = args.dup
      expect(cur_args.delete(field_to_delete)).to eq(args[field_to_delete])
      expect { Work.create!(cur_args) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'object update' do

    let(:update_args) {
      { :title => 'Updated Title', :program_notes_it => 'note di test aggiornate' }
    }

    it 'updates the object properly when needed' do
      expect((w = Work.create!(args)).class).to be(Work)
      expect(w.update!(update_args)).to eq(true)
      update_args.each { |k, v| expect(w.send(k)).to eq(v) }
    end

  end

end
