module OpenidValidatable
  extend ActiveSupport::Concern

  included do
    attr_accessor :openid_errors
    validate :openid_url_has_no_issues
  end

  def openid_url_has_no_issues
    (openid_errors || []).each do |openid_error|
      errors.add(:openid_url, openid_error)
    end
  end

  def add_bad_openid_url_error
    (self.openid_errors ||= []) << :bad_openid_url
  end
end