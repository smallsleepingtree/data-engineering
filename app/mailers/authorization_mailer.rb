class AuthorizationMailer < ActionMailer::Base
  default from: "admin@smallsleepingtree.com"

  def pending_authorization(user, admins)
    @user = user
    @admins = admins
    mail :to => admins.map(&:email), :subject => t('mail.authorization.pending.subject')
  end

  def authorize_notification(user)
    notification(user, :authorize)
  end

  def reject_notification(user)
    notification(user, :reject)
  end

private

  def notification(user, decision)
    @user = user
    mail :to => user.email, :subject => t("mail.authorization.#{decision}.subject"),
      :template_name => "#{decision}_notification"
  end
end
