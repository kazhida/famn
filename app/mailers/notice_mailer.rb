# -*- encoding: utf-8 -*-

class NoticeMailer < ActionMailer::Base
  default :from => 'info@famn.mobi'

  def notify(entry)
    @entry = entry
    unless entry.family.login_name == 'visitor'
      dest = []
      User.by_family_id(entry.family.id).each do |user|
        if user.notice?(entry.destinations)
          dest.push %!#{user.mail_address}!  unless /@example¥.com/ =~ user.mail_address
        end
      end
      unless dest.empty?
        mail(
            :to => dest,
            :subject => "[famn.mobi] #{entry.user.display_name}さんのメッセージ"
        ) do |format|
          format.html
          format.text
        end.deliver
      end
    end
  end
end
