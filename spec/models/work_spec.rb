require 'rails_helper'

RSpec.describe Work, type: :model do

  before :example do
    @num_authors = 3
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
    args.update(:authors_attributes => @authors, :roles_attributes => build_roles(@authors),
      :submitted_files_attributes => build_submitted_files(@w, @num_submitted_files),
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
      (cleaned_args, authors, roles, submitted_files) = Work.clean_args(ActionController::Parameters.new(work: full_args))
      expect((work = Work.create!(work_params(cleaned_args))).valid?).to eq(true)
    end

    it 'creates a work with many authors and many roles' do
      expect((work = Work.create!(args)).valid?).to eq(true)
      roles = build_roles(@authors)
      work.update_all_roles roles
      expect(work.authors(true).uniq.count).to eq(roles.size)
      roles.each { |r| expect(work.authors.find(r[:author_id]).roles(true).count).to eq(r[:roles_attributes].size-1) } # argument has an extra empty element
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

    it 'actually destroys the links with the author when destroyed' do
      num_works = 3
      num_authors = 1
      num_roles = 2
      expect((ws = FactoryGirl.create_list(:work_with_authors_and_roles, num_works, num_authors: 1, num_roles: 2)).size).to eq(num_works)
      ws.each do
        |w|
        expect(w.authors_with_roles(true).count).to eq(num_authors)
        expect(w.authors(true).uniq.count).to eq(num_authors)
        #
        # we have `num_authors` different authors linked to each work, so each
        # author has just one work
        #
        expect(wras = w.works_roles_authors(true).count).to eq(num_authors*num_roles)
        w.destroy
        expect(WorkRoleAuthor.where('work_id = ?', w.id).count).to eq(0)
      end
    end

  end

  context 'associations' do

    it 'can link authors to a single work' do
      num_authors = 3
      expect((w = FactoryGirl.create(:work)).valid?).to be(true)
      expect((as = FactoryGirl.create_list(:author, num_authors, owner_id: @account.to_param)).class).to be(Array)
      expect((r = Role.music_composer).valid?).to be(true)
      as.each { |a| w.add_author_with_roles(a, r) }
      expect(w.authors(true).uniq.count).to eq(num_authors)
    end

    it 'can link authors through multiple works' do
      num_works = 3
      num_authors = 5
      expect((r = Role.music_composer).valid?).to be(true)
      expect((as = FactoryGirl.create_list(:author, num_authors, owner_id: @account.to_param)).class).to be(Array)
      expect((ws = FactoryGirl.create_list(:work, num_works)).class).to be(Array)
      ws.each { |w| as.each { |a| w.add_author_with_roles(a, r) } }
      ws.each { |w| expect(w.authors(true).uniq.count).to eq(num_authors) }
    end

    it 'lists authors and works properly' do
      num_works = 3
      num_authors = 5
      expect((ws = FactoryGirl.create_list(:work_with_authors_and_roles, num_works, num_authors: num_authors)).class).to be(Array)
      ws.each do
        |work|
        expect(work.authors_with_roles(true).size).to eq(num_authors)
        work.authors_with_roles.each do
          |wra_hash|
          expect(wra_hash.has_key?(:author_id)).to be(true)
          expect(wra_hash.has_key?(:roles_attributes)).to be(true)
          expect((auth = Author.find(wra_hash[:author_id])).kind_of?(Author)).to be(true)
          expect(wra_hash[:roles_attributes].size).to eq(WorkRoleAuthor.where('author_id = ? and work_id = ?', auth.to_param, work.to_param).count)
          wra_hash[:roles_attributes].each { |r_a| expect(auth.roles.where('roles.id = ?', r_a[:id]).uniq.count).to eq(1) }
        end
      end
    end

    it 'displays roles properly' do
      nr = 3
      na = 1
      work = FactoryGirl.create(:work_with_authors_and_roles, num_authors: na, num_roles: nr)
      author = work.authors(true).uniq.last
      expect((wras = WorkRoleAuthor.where('author_id = ? and work_id = ?', author.to_param, work.to_param)).size).to eq(nr)
      string_result = wras.map { |wra| wra.role.description }.sort.join(', ')
      expect(work.display_roles(author)).to eq(string_result)
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

  #
  # +build_roles(authors)+ builds the proper role argument for each author
  #
  # we need to simulate the behaviour of the view. For this reason we add an
  # extra empty 'id' element to the roles (needed by the checkbox collection).
  #
  def build_roles(authors)
    res = []
    max_num_roles = Role.count-1
    authors.each do
      |a|
      num_roles = Forgery(:basic).number(:at_least => 1, :at_most => 4)
      roles = []
      1.upto(num_roles) { roles << Role.all[Forgery(:basic).number(:at_least => 0, :at_most => max_num_roles)] }
      roles = roles.uniq.map { |r| { 'id' => r.id.to_s } }
      roles << { 'id' => '' } # empty (wrong) element added by the view
      h = HashWithIndifferentAccess.new(author_id: a.id.to_s, roles_attributes: roles)
      res << h
    end
    res
  end

  #
  # +build_submitted_files(n_sfs) builds the appropriate number of submitted
  # files
  #
  def build_submitted_files(work, n_sfs)
    FactoryGirl.build_list(:submitted_file_without_association, n_sfs, work_id: work.to_param).map { |sf| sf.attributes }
  end

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
