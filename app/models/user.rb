# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  created_at      :datetime
#  updated_at      :datetime
#  name            :text
#  email           :text
#  password_digest :text
#  remember_token  :string(255)
#  frequency_value :integer
#  frequency       :text
#

class User < ActiveRecord::Base
  has_secure_password
  
  before_save {|user| user.email = email.downcase}
  before_create :create_remember_token
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, presence: true
  validates :email, presence: true,
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true, on: :create, length: {minimum: 6}
  validates :password_confirmation, presence: true, on: :create

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  

  private  
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
  
  def calculate_next_time(person) 	
  end
end
