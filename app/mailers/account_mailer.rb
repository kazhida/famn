# -*- encoding: utf-8 -*-

class AccountMailer < ActionMailer::Base
  default :from => 'info@abplus.com', :charset => 'utf-8'

  def email_verification(user)
    @user = user
    mail(:to => user.mail_address, :subject => '[famn] メールアドレスの確認')
  end
end
