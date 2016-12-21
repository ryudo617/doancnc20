class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :confirmable,:database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2],
         :authentication_keys => [:username]
  enum role: [:member, :admin]

  validates :username, presence: true, uniqueness: true
  validates :phone, presence: true
  validates :phone, numericality: {only_integer: true}
  validates_length_of :phone, minimum: 10, maximum: 11, allow_blank: true
  validates_length_of :password_confirmation, minimum: 6,on: :create
  has_many :wish_lists, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :order_members,dependent: :destroy
  validates :password, :password_confirmation,length: {minimum: 6, maximum: 12}, on: :update, allow_blank: true
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.search(search)
    if search
      where('LOWER(username) LIKE ? or LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ?',"%#{search.downcase}%","%#{search.downcase}%","%#{search.downcase}%")
    else
      # scoped
      all
    end
  end
end
