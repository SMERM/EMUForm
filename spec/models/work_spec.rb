require 'rails_helper'
require_relative File.join('..', 'support', 'work_builder')

RSpec.describe Work, type: :model do

  before :example do
    @num_authors = 3
    @num_roles = 2
    @account = FactoryGirl.create(:account)
    @authors = FactoryGirl.create_list(:author, @num_authors, owner_id: @account.to_param)
    @w = nil # this is where we set the work
    @num_submitted_files = Forgery(:basic).number(at_least: 1, at_most: 5)
  end

  after :example do
    zoot_file_directory
  end

  let(:args) {
    HashWithIndifferentAccess.new(:title => Forgery(:name).title,
      :'year(1i)' => Forgery(:basic).number(:at_least => 1850, :at_most => Time.zone.now.year).to_s, :'year(2i)' => '1', :'year(3i)' => '1',
      :'duration(1i)' => '1', :'duration(2i)' => '1', :'duration(3i)' => '1',
      :'duration(4i)' => '0', :'duration(5i)' => '4', :'duration(6i)' => '33',
      :instruments => 'pno, fl, cl',
      :program_notes_en => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 3)),
      :program_notes_it => Forgery(:lorem_ipsum).paragraphs(Forgery(:basic).number(:at_least => 1, :at_most => 3)),
      :owner_id => @account.to_param,
    )
  }

  let(:full_args) {
    args.update(authors_attributes: build_authors_and_roles_attributes(@authors, @num_roles),
      submitted_files_attributes: build_submitted_files_attributes(@num_submitted_files),
    )
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
        sub_fields = args.keys.grep(/#{field_to_delete.to_s}/)
        cur_args = args.dup
        sub_fields.each { |ftd| expect(cur_args.delete(ftd)).to eq(args[ftd]) }
        expect { Work.create!(cur_args) }.to raise_error(ActiveRecord::RecordInvalid), field_to_delete.to_s
      end
    end

    it 'creates an object along with its nested submitted files' do
      expect((work = Work.create!(full_args)).valid?).to eq(true)
      expect(work.submitted_files(true).count).to eq(@num_submitted_files)
      work.submitted_files.each { |sf| expect(File.exists?(sf.attached_file_full_path)).to be(true) }
    end

    it 'creates a work with many authors and many roles' do
      expect((work = Work.create!(full_args)).valid?).to eq(true)
      expect(work.authors(true).uniq.count).to eq(@num_authors)
      work.authors.uniq.each { |a| expect(a.roles.for_work(work.to_param).count).to eq(@num_roles) }
    end

  end

  context 'object i/o' do

    it 'conditions a year insertion appropriately' do
      expect((@w = Work.create!(args)).valid?).to eq(true)
      expect(@w.year).to eq(Time.zone.local(args['year(1i)'].to_i) + 2.days)
    end
  
    it 'conditions the display of duration appropriately' do
      expect((@w = Work.create!(args)).valid?).to eq(true)
      expect(@w.display_duration).to eq(Time.zone.local(1,1,1,args['duration(4i)'].to_i, args['duration(5i)'].to_i, args['duration(6i)'].to_i).strftime("%H:%M:%S"))
    end
  
    it 'conditions the display of year appropriately' do
      expect((@w = Work.create!(args)).valid?).to eq(true)
      expect(@w.display_year).to eq((Time.zone.local(args['year(1i)'].to_i) + 2.days).year)
    end

  end

  context 'object update' do

    before :example do
      @num_other_authors = 4
      @num_other_roles = 5
      @other_authors = FactoryGirl.create_list(:author, @num_other_authors, owner_id: @account.to_param)
    end

    let(:update_args) {
      HashWithIndifferentAccess.new(:title => 'Updated Title', :program_notes_it => 'note di test aggiornate')
    }

    let(:full_update_args) do
      h = HashWithIndifferentAccess.new(update_args)
      h.update(authors_attributes: build_authors_and_roles_attributes(@other_authors, @num_other_roles))
      h
    end

    it 'updates the object properly when needed' do
      expect((@w = Work.create!(args)).class).to be(Work)
      expect(@w.update!(update_args)).to eq(true)
      update_args.each { |k, v| expect(@w.send(k)).to eq(v) }
    end

    it 'updates the object with all the nested attributes properly when needed' do
      expect((@w = Work.create!(full_args)).class).to be(Work)
      expect(@w.update!(full_update_args)).to eq(true)
      update_args.each { |k, v| expect(@w.send(k)).to eq(v) }
      expect(@w.authors(true).uniq.count).to eq(@num_other_authors + @num_authors)
      @w.authors.uniq.each { |a| expect(a.roles(true).for_work(@w.to_param).count).to be >= @num_roles }
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

    it 'actually destroys the links with the author when destroyed' do
      num_works = 3
      num_authors = 1
      num_roles = 2
      expect((ws = FactoryGirl.create_list(:work_with_authors_and_roles, num_works, num_authors: 1, num_roles: 2)).size).to eq(num_works)
      ws.each do
        |w|
        expect(w.authors(true).uniq.count).to eq(num_authors)
        w.authors.uniq.each { |a| expect(a.roles.for_work(w.to_param).count).to eq(num_roles) }
        #
        # we have `num_authors` different authors linked to each work, so each
        # author has just one work
        #
        expect(wras = w.works_roles_authors(true).count).to eq(num_authors*num_roles)
        w.destroy
        expect(WorkRoleAuthor.where('work_id = ?', w.id).count).to eq(0)
      end
    end

    it 'uploads the submitted files properly' do
      expect((w = Work.create(full_args)).valid?).to be(true)
      expect(w.submitted_files(true).count).to eq(@num_submitted_files)
      w.submitted_files.each do
        |sf|
        expect(File.exists?(sf.attached_file_full_path)).to be(true)
        expect(File.size(sf.attached_file_full_path)).to eq(sf.size)
      end
    end

  end

  context 'associations' do

    it 'can link authors to a single work' do
      num_authors = 3
      num_roles = 1
      expect((w = FactoryGirl.create(:work)).valid?).to be(true)
      expect((as = FactoryGirl.create_list(:author, num_authors, owner_id: @account.to_param)).class).to be(Array)
      as_attrs = build_authors_and_roles_attributes(as, num_roles)
      expect(w.update!(authors_attributes: as_attrs)).to be(true)
      expect(w.authors(true).uniq.count).to eq(num_authors)
      w.authors.uniq.each { |a| expect(a.roles(true).for_work(w.to_param).count).to eq(num_roles) }
    end

    it 'can link authors through multiple works' do
      num_works = 3
      num_authors = 5
      num_roles = Role.count - 3
      expect((as = FactoryGirl.create_list(:author, num_authors, owner_id: @account.to_param)).class).to be(Array)
      expect((ws = FactoryGirl.create_list(:work, num_works)).class).to be(Array)
      ws.each do
        |w|
        as_h = build_authors_and_roles_attributes(as, num_roles)
        expect(w.update!(authors_attributes: as_h)).to be(true)
      end
      ws.each { |w| expect(w.authors(true).uniq.count).to eq(num_authors) }
      ws.each { |w| w.authors.uniq.each { |a| expect(a.roles(true).for_work(w.to_param).count).to eq(num_roles) } }
    end

    it 'displays authors and works properly' do
      num_works = 3
      num_authors = 5
      num_roles = 2
      expect((ws = FactoryGirl.create_list(:work_with_authors_and_roles, num_works, num_authors: num_authors, num_roles: num_roles)).class).to be(Array)
      ws.each do
        |work|
        expect(work.authors(true).uniq.count).to eq(num_authors)
        work.authors.uniq.each { |a| expect(a.roles(true).for_work(work.to_param).count).to eq(num_roles) }
        ar_array = []
        work.authors.uniq.each do
          |a|
          a_array = [ a.full_name ]
          a_array << ('(' + a.roles.for_work(work.to_param).map { |r| r.description }.join(', ') + ')')
          ar_array << a_array.join(' ')
        end
        expect(work.display_authors_with_roles).to eq(ar_array.join(', '))
      end
    end

  end

private

  def zoot_file_directory
    if @w && @w.valid?
      expect((dir = @w.directory).blank?).to eq(false)
      @w.destroy
      expect(@w.frozen?).to eq(true)
      expect(Dir.exists?(dir)).to eq(false)
    end
  end

  include WorkBuilderSpecHelper # contains: build_authors_and_roles_attributes and build_submitted_files_attributes

  #
  # lifted from app/controllers/works_controller.rb (needed for parameter permission check)
  #
  def work_params(parms)
    WorksController.new.send(:work_params, parms)
  end

  #
  # +find_author(author, roles_attributes)+ finds an author inside a roles_attributes
  # which is like that:
  # <tt>[{:author_id => a_id1, :roles_attributes => [ r_id1, r_id2, ... ]}, {:author_id => a_id2, ... }]</tt>
  #
  def find_author(a, r_a)
    res = nil
    r_a.each do
      |ras|
      if a.id.to_s == ras[:author_id].to_s
        res = ras
        break
      end
    end
    res
  end

end
