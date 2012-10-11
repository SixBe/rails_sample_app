# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
	attr_accessible :email, :name, :password, :password_confirmation
	has_secure_password # single method to ensure proper management of password including authentication

	# Validation of name
	validates :name, presence: true, length: { maximum: 50 }
	
	# Validation of email
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, 
		format: { with: VALID_EMAIL_REGEX }, 
		uniqueness: { case_sensitive: false }

	before_save { self.email.downcase! }
	before_save { self.name.squish! } # remove all extra white space (leading/trailing/multiple)

	# Validation of password
	validates :password, length: { minimum: 6 }
	validates :password_confirmation, presence: true
end
