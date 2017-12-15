class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: %i[auth0]
         
         
  def self.from_omniauth(auth)
    byebug
    where('(provider = ? AND uid = ?) OR name = ?', auth.provider, auth.uid, auth.info.name).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.provider = auth.provider
      user.uid = auth.uid
      #user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
  
  def self.new_with_session(params, session)
    byebug
    super.tap do |user|
      if data = session["devise.auth0_data"] && session["devise.auth0_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
