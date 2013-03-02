# -*- encoding: utf-8 -*-

class NoticeMailer < ActionMailer::Base
  default :from => 'info@famn.jp'

  def notify(entry)
    @entry = entry
    User.by_family_id(entry.family.id).each do |user|
      if user.notice?(entry.destinations)
        mail(
            :to => user.mail_address,
            :subject => "[famn.mobi] #{entry.user.display_name}さんのメッセージ"
        ) do |format|
          format.html
          format.text
        end.deliver
      end
    end
  end
end
