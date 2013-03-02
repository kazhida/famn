# -*- encoding: utf-8 -*-

class NoticeMailer < ActionMailer::Base
  default :from => 'info@famn.jp'

  def notify(entry)
    @entry = entry
    bcc = []
    User.by_family_id(entry.family.id).each do |user|
      if user.notice?(entry.destinations) && user != entry.user
        bcc.push %!#{user.mail_address}!
      end
    end
    mail(
        :to => entry.user.mail_address,
        :bcc => bcc,
        :subject => "[famn.mobi] #{entry.user.display_name}さんのメッセージ"
    ) do |format|
      format.html
      format.text
    end.deliver
  end
end
