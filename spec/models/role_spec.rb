require 'rails_helper'

RSpec.describe Role, type: :model do

  it 'has the static roles pre-loaded' do
    sroles = YAML.load(File.open('./config/roles.yml', 'r')).keys.sort
    sroles.each { |sr| expect(Role.where('description = ?', sr).empty?).to be(false) }
  end

end
