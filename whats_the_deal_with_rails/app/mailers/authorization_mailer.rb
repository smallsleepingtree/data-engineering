class AuthorizationMailer < ActionMailer::Base
  default from: "from@example.com"

  def pending_authorization(user, admin)
    @user = user
    @admin = admin
    mail :to => admin.email, :subject => t('mail.authorization.pending.subject')
  end
end
