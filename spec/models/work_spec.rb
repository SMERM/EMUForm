require 'rails_helper'

RSpec.describe Work, type: :model do

  before :example do
    @w = nil # this is where we set the work
  end

  after :example do
    zoot_file_directory
  end

  let(:args) {
    HashWithIndifferentAccess.new(:title => 'Test', :year => Time.zone.parse('2016-01-01'), :duration => Time.zone.parse('00:03:03'), :instruments => 'pno', :program_notes_en => 'test notes', :program_notes_it => 'note di test')
  }

  context 'object creation' do

    it 'does not raise errors immediately when running :new' do
      expect((@w = Work.new).class).to be(Work)
      expect(@w.errors.any?).to be(false), "it raises the following errors \"#{@w.errors.full_messages.join(', ')}\""
    end

    it 'does full field validation' do
      expect((@w = Work.new).class).to be(Work)
      expect { @w.save! }.to raise_error(ActiveRecord::RecordInvalid)
      expect((@w = Work.create!(args)).class).to be(Work)
      expect((dir = @w.directory).blank?).to eq(false)
    end
  
    it 'does individual field validation' do
      v_fields = [:title, :year, :duration, :instruments, :program_notes_en]
      expect((@w = Work.create(args)).valid?).to eq(true)
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

    it 'creates an object along with its nested objects' do
      params = args
      n_sfs = 3
      sfs = FactoryGirl.create_list(:uploaded_file, n_sfs)
    end

  end

  context 'object i/o' do

    it 'conditions a year insertion appropriately' do
      expect((@w = Work.create!(args)).valid?).to eq(true)
      expect(@w.year).to eq(args[:year] + 2.days)
    end
  
    it 'conditions the display of duration appropriately' do
      expect((@w = Work.create!(args)).valid?).to eq(true)
      expect(@w.display_duration).to eq(args[:duration].strftime("%H:%M:%S"))
    end
  
    it 'conditions the display of year appropriately' do
      expect((@w = Work.create!(args)).valid?).to eq(true)
      expect(@w.display_year).to eq((args[:year] + 2.days).year)
    end

  end

  context 'object update' do

    let(:update_args) {
      HashWithIndifferentAccess.new(:title => 'Updated Title', :program_notes_it => 'note di test aggiornate')
    }

    it 'updates the object properly when needed' do
      expect((@w = Work.create!(args)).class).to be(Work)
      expect(@w.update!(update_args)).to eq(true)
      update_args.each { |k, v| expect(@w.send(k)).to eq(v) }
    end

  end

  context 'object creation' do

    it 'creates the directory automatically (if not passed as argument)' do
      expect((@w = Work.create!(args)).valid?).to eq(true)
      expect(@w.directory.blank?).to eq(false)
      expect(Dir.exists?(@w.directory)).to eq(true)
    end

    it 'does create the directory with the given name if passed' do
      dirpath = File.join(Work::UPLOAD_BASE_PATH, 'test_dir')
      args.update(:directory => dirpath)
      expect((@w = Work.create!(args)).valid?).to eq(true)
      expect(@w.directory).to eq(dirpath)
      expect(Dir.exists?(@w.directory)).to eq(true)
      expect(Dir.exists?(dirpath)).to eq(true)
    end

    it 'does not create the directory if it exists already' do
      dir = Dir::Tmpname.make_tmpname(Work::UPLOAD_PREFIX, '')
      Dir.mkdir(dir, 0700)
      expect(Dir.exists?(dir)).to eq(true)
      args.update(:directory => dir)
      expect((@w = Work.create!(args)).valid?).to eq(true)
      expect(@w.directory).to eq(dir)
      expect(Dir.exists?(@w.directory)).to eq(true)
      expect(Dir.exists?(dir)).to eq(true)
    end

  end

  context 'object destruction' do

    it 'is able to properly destroy everything when needed' do
      expect((@w = Work.create!(args)).valid?).to eq(true)
      expect(@w.directory.blank?).to eq(false)
      expect(Dir.exists?(@w.directory)).to eq(true)
      #
      dir = @w.directory
      @w.destroy
      expect(@w.frozen?).to eq(true)
      expect(@w.directory.blank?).to eq(true)
      expect(Dir.exists?(dir)).to eq(false)
      @w = nil
    end

  end

  def zoot_file_directory
    if @w && @w.valid?
      expect((dir = @w.directory).blank?).to eq(false)
      @w.destroy
      expect(@w.frozen?).to eq(true)
      expect(Dir.exists?(dir)).to eq(false)
    end
  end

end
