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

#
# This is needed to have at least one (current) edition...
#
Edition.send(:create!, current: true, year: 2016, title: "La Ginnastica dell'Orecchio", start_date: "2016-10-24", end_date: "2016-10-29", description_en: "Gymnastics is good for you", description_it: "La Ginnastica fa Bene")

#
# ... and to have some preset categories for development
#
categories =
[
  { acro: 'ACOU', title_en: 'Acousmatic Work', title_it: 'Lavoro Acusmatico', description_en: 'Fixed media work for speakers only', description_it: 'Lavoro acusmatico per soli altoparlanti' },
  { acro: 'LIVE', title_en: 'Live-Electronics Work', title_it: 'Lavoro con Live-Electronics', description_it: 'Lavoro per strumenti e live-electronics', description_en: 'Instrumental work with live-electronics' },
  { acro: 'INST', title_en: 'Sound installation', title_it: 'Installazione sonora', description_en: 'Autonomous sound installation, sound sculpture', description_it: 'Installazione sonora autonoma, scultura sonora' },
]
categories.each { |cargs| Category.create(cargs) }
#
# we set only the first two in the current edition
#
