# frozen_string_literal: true

# User model
class User < ApplicationRecord
  enum role: { member: 0, admin: 1 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, :first_name, :last_name, presence: true
  validates :username, uniqueness: true
end
