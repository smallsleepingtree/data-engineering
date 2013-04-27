require 'openid_validatable'

class Session
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming
  include OpenidValidatable

  attr_accessor :openid_url, :email, :password

  validates :email, :presence => true, :unless => :openid_url
  validates :openid_url, :presence => true, :unless => :email
  validate :require_email_or_openid

  def require_email_or_openid
    if email.blank? && openid_url.blank?
      errors.add(:email, :or_openid_url)
      errors.add(:openid_url, :or_email)
    end
  end

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end