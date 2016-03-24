class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.integer :year,                 null: false, unique: true
      t.string :title,                 null: false
      t.datetime :start_date
      t.datetime :end_date
      t.text :description_en
      t.text :description_it
      t.datetime :submission_deadline
      #
      # +current+ cannot be a boolean because it makes it impossible to
      # actually validate the object (since it validates against +blank?+).
      # Thus we have to make it a string which may have only two values:
      # 'TRUE' and 'FALSE'
      #
      t.string  :current,              null: false, default: 'FALSE'

      t.timestamps                     null: false
    end
  end
end
