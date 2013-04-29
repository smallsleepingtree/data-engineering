require 'openid_validatable'

class User < ActiveRecord::Base
  include OpenidValidatable

  attr_accessible :email, :password, :password_confirmation, :openid_url

  has_secure_password

  validates :email, :uniqueness => true, :presence => true, :format => /.+@[\w\-]+\.[\w\-]+/
  validates :password, :presence => true, :if => :password, :unless => lambda { openid_url.present? }
  validates :openid_url, :presence => true, :if => :openid_url, :unless => lambda { password.present? }
  validates :openid_url, :uniqueness => true, :on => :create, :allow_blank => true

  validate :require_only_one_of_password_or_openid

  def require_only_one_of_password_or_openid
    if openid_url.present? && password.present?
      errors[:password].clear
      errors.add(:password, :unnecessary)
    end
  end

  before_validation do
    if openid_url.present?
      self.password_digest = '0'
    else
      self.openid_url = nil
    end
  end

  after_create do
    unless authorized? || admin? || User.first_admin.nil?
      AuthorizationMailer.pending_authorization(self, User.first_admin).deliver
    end
  end

  def needs_openid_verification?
    openid_url.present? && openid_url_changed?
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
