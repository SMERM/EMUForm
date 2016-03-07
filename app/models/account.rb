class Account < ActiveRecord::Base

  has_many :authorizations
  has_many :works,   dependent: :destroy, foreign_key: :owner_id
  has_many :authors, dependent: :destroy, foreign_key: :owner_id

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  accepts_nested_attributes_for :authors, allow_destroy: true

  validates_presence_of :email, :last_name, :first_name

# mount_uploader :image, ImageUploader

  def self.new_with_session(params,session)
    if session["devise.account_attributes"]
      new(session["devise.account_attributes"],without_protection: true) do |account|
        account.attributes = params
        account.valid?
      end
    else
      super
    end
  end

  def self.from_omniauth(auth, current_account)
    authorization = Authorization.where(:provider => auth.provider, :uid => auth.uid.to_s, :token => auth.credentials.token, :secret => auth.credentials.secret).first_or_initialize
    if authorization.account.blank?
      account = current_account || Account.where('email = ?', auth["info"]["email"]).first
      if Account.blank?
       account = Account.new
       account.password = Devise.friendly_token[0,10]
       account.name = auth.info.name
       account.email = auth.info.email
       if auth.provider == "twitter"
         account.save(:validate => false)
       else
         account.save
       end
     end
     authorization.username = auth.info.nickname
     authorization.account_id = account.id
     authorization.save
   end
   authorization.account
 end

end
