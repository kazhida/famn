# -*- encoding: utf-8 -*-

class AccountMailer < ActionMailer::Base
  default :from => 'info@famn.mobi'

  def email_verification(admin, user)
    @admin = admin
    @user  = user
    mail(
        :to => user.mail_address,
        :subject => '[famn.mobi] メールアドレスの確認'
    ) do |format|
      format.html
      format.text
    end
  end
end
