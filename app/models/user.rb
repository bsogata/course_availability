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
# Based heavily on the User model in the Ruby on Rails tutorial by Michael Hartl at:
# http://ruby.railstutorial.org/
#
# Author: Hansen Cheng
#         Branden Ogata
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
  validates :frequency_value, numericality: {greater_than: 0}

  #
  # Generates a new security token for a user.
  #
  # Returns:
  #   The new security token.
  #
  # Author: Branden Ogata
  #

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  #
  # Encrypts a security token for secure transfer.
  #
  # Parameters:
  #   token    The token to encrypt.
  #
  # Returns:
  #   The encrypted token.
  #
  # Author: Branden Ogata
  #

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  

  private
  
    #
    # Generates and stores a new security token for this User.
    #
    # Author: Branden Ogata
    #
    
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
    
    #
    # Calculates the next time to send emails to this User.
    #
    # Ultimately not used in this project.
    #
    # Author: Hansen Cheng
    #
    
    def calculate_next_time(person) 	
    end
end
