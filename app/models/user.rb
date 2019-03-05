require 'user_auth'

class User < ActiveRecord::Base
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: {with: /@/}

  def to_s
    name
  end

  def token
    UserAuth::Token.encode(id: id)
  end
end
