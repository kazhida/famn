# -*- encoding: utf-8 -*-

FactoryGirl.define do

  factory :user do
    sequence(:login_name)   {|n| "ryoma#{n}" }
    sequence(:display_name) {|n| "龍馬#{n}" }
    password 'foobar'
    mail_address 'ryoma@example.com'
    family_id 1
    face 'gray'
    aruji  false
  end
end