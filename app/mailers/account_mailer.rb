# -*- encoding: utf-8 -*-

class AccountMailer < ActionMailer::Base
  default :from => 'info@famn.jp'

  def email_verification(admin, user)
    @admin = admin
    @user  = user
    mail(
        :to => user.mail_address,
        :subject => '[famn] メールアドレスの確認'
    )
  end
end
