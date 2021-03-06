# User class used to manage application users
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:admin, :app_user, :designer, :banned, :editor, :photographer, :guest]
  has_one :user

  after_create :build_user

  def build_user
    User.create(user: self)
  end
end
