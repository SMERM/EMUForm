#
# +Edition+
#
# carries all the info concerning EMUFest editions
#
# It peculiarity is that there may be only one +current+ edition (current:
# true) at a time.
#
class Edition < ActiveRecord::Base

  has_and_belongs_to_many :categories
  has_many :works

  extend Enumerize

  class OnlyOneValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)
      record.errors.add attribute, "attribute cannot be set to true for more than one #{record.class}" unless (value == 'false' ||
                                                                             (record.class.where("#{attribute} = ?", :true).count == 0) ||
                                                                             (record.class.where("#{attribute} = ?", :true).first == record))
    end

  end

  enumerize :current, in: [:true, :false], default: :false

  validates_presence_of :year, :title, :current
  validates_uniqueness_of :year
  validates :current, only_one: true

  #
  # Editions cannot be created in the usual way in order to make sure that
  # only one is current. It should be created through the +switch+ method
  # (see below)
  #
  private_class_method :new, :create, :create!
  
  class << self

    #
    # +current+
    #
    # returns the current edition
    #
    def current
      where('current = ?', :true).first
    end

    #
    # +past+
    #
    # returns past editions
    #
    def past
      where('current = ?', :false)
    end

    #
    # <tt>switch(args = {})</tt>
    #
    # switch the edition passed in the arguments to be the current edition
    # (must be saved in order to be actually created in the database)
    #
    def switch(args = {})
      cur = current
      cur.update(current: false)
      cur.save
      args.update(current: true)
      new(args)
    end

    #
    # <tt>switch!(args = {})</tt>
    #
    # +switch!+ creates, switches to current and saves the +Edition+ object
    #
    def switch!(args = {})
      obj = switch(args)
      obj.save!
      obj
    end

  end

end
