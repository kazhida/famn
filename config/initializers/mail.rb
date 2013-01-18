ActionMailer::Base.smtp_settings = {
    :address        => ENV['FAMN_SMTP_ADDRESS']        || 'smtp.sendgrid.net',
    :port           => ENV['FAMN_SMTP_PORT']           ||  587,
    :authentication => ENV['FAMN_SMTP_AUTHENTICATION'] || :plain,
    :domain         => ENV['FAMN_SMTP_DOMAIN']         || 'heroku.com',
    :user_name      => ENV['FAMN_SMTP_USER_NAME']      || ENV['SENDGRID_PASSWORD'],
    :password       => ENV['FAMN_SMTP_PASSWORD']       || ENV['SENDGRID_USERNAME']
}
ActionMailer::Base.delivery_method = :smtp
