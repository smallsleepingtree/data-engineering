class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  has_secure_password

  validates :email, :uniqueness => true

  after_create do
    unless authorized? || admin? || User.first_admin.nil?
      AuthorizationMailer.pending_authorization(self, User.first_admin).deliver
    end
  end

  def self.first_admin
    where(:admin => true).first
  end
end
