require 'openid'
require 'openid/store/filesystem'

class OpenidAgent
  attr_accessor :user_attributes
  attr_reader :response

  def initialize(session)
    @session = session
  end

  def consumer
    @consumer ||= OpenID::Consumer.new(@session,
      OpenID::Store::Filesystem.new(File.join(Rails.root, 'tmp', 'openid')))
  end

  def redirect_url(openid_url, options = {})
    realm, return_to = options.fetch(:realm), options.fetch(:return_to)
    entity = options[:entity]
    openid_request = consumer.begin(openid_url)
    openid_request.redirect_url(realm, return_to)
  rescue OpenID::DiscoveryFailure => e
    entity && entity.add_bad_openid_url_error
    nil
  end

  def complete(params, return_to)
    @response ||= consumer.complete(params, return_to)
  end

  def user
    @user ||= begin
      if response.identity_url
        user = User.find_by_openid_url(response.identity_url)
      end
      user ||= User.new({:openid_url => response.identity_url}.merge(user_attributes))
    end
  end

  def status
    @status ||= case response.status
    when OpenID::Consumer::FAILURE
      :failure
    when OpenID::Consumer::SUCCESS
      :success
    when OpenID::Consumer::CANCEL
      :cancelled
    end
  end
end