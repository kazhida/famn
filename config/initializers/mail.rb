ActionMailer::Base.smtp_settings =
    if ENV['FAMN_SMTP_PASSWORD'].nil
      {
          :address        => ENV['FAMN_SMTP_ADDRESS']        || 'localhost',
          :port           => ENV['FAMN_SMTP_PORT']           ||  25
      }
    else
      {
          :address        => ENV['FAMN_SMTP_ADDRESS']        || 'smtp.sendgrid.net',
          :port           => ENV['FAMN_SMTP_PORT']           ||  587,
          :authentication => ENV['FAMN_SMTP_AUTHENTICATION'] || :plain,
          :domain         => ENV['FAMN_SMTP_DOMAIN']         || 'heroku.com',
          :user_name      => ENV['FAMN_SMTP_USER_NAME']      || ENV['SENDGRID_USERNAME'],
          :password       => ENV['FAMN_SMTP_PASSWORD']       || ENV['SENDGRID_PASSWORD']
      }
    end
ActionMailer::Base.delivery_method = :smtp
