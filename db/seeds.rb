# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
# This was added by the ActiveAdmin installation
#
AdminAccount.create!(email: 'admin@emufest.org', password: 'minimoog', password_confirmation: 'minimoog')

#
# What follows is needed to install the static roles that should always be
# present on an installed base.
#
EMUForm::RoleManager.setup
