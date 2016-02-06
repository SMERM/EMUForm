require 'rails_helper'

RSpec.describe Role, type: :model do

  before :example do
    Role.destroy_all
    EMUForm::RoleManager.setup
    @num_static_roles = Role.count
  end

  after :example do
    Role.destroy_all
  end

  it 'preloads the static roles' do
    expect(Role.count).to eq(@num_static_roles)
  end

  it 'does not preload them twice' do
    expect(Role.count).to eq(@num_static_roles)
    EMUForm::RoleManager.setup
    expect(Role.count).to eq(@num_static_roles) # count does not change
  end

  it 'prevents from deleting user-added roles (non-static)' do
    expect(Role.count).to eq(@num_static_roles)
    added_role = FactoryGirl.create(:role)
    expect(Role.count).to eq(@num_static_roles + 1)
    EMUForm::RoleManager.clear
    expect(Role.count).to eq(1)
  end

  it 'has class methods corresponding to the static roles' do
    expect((srs = EMUForm::RoleManager.send(:load_static_role_names)).kind_of?(Array)).to be(true)
    expect(srs.blank?).to be(false)
    srs.each do
      |sr|
      srname = sr.gsub(/\s+/, '').underscore.to_sym
      expect(Role.respond_to?(srname)).to be(true)
    end
  end

end
