class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation

  has_secure_password

  validates :email, :uniqueness => true

  after_create do
    unless authorized? || admin? || User.first_admin.nil?
      AuthorizationMailer.pending_authorization(self, User.first_admin).deliver
    end
  end

  def authorize!
    authorize_or_reject!(:authorize)
  end

  def reject!
    authorize_or_reject!(:reject)
  end

  def self.first_admin
    where(:admin => true).first
  end

  def self.pending
    where(:authorized => false, :rejected_at => nil)
  end

private

  def authorize_or_reject!(decision)
    self.authorized = decision == :authorize
    self.rejected_at = decision == :authorize ? nil : Time.now
    save!
    AuthorizationMailer.send("#{decision}_notification".to_sym, self).deliver
  end
end
