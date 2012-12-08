# -*- encoding: utf-8 -*-

require 'spec_helper'

describe User do
  # Userがもっているフィールドは、
  #   login_name
  #   display_name
  #   password_digest
  #   mail_address
  #   aruji

  before(:all) do
    User.destroy_all
  end

  before(:each) do
    # まっさらなユーザを作る
    @user = User.new
  end

  it 'login_nameがなければ保存できない。' do
    @user.save.should be_false
  end

  it 'display_nameがなければ保存できない。' do
    @user.login_name = 'foo'
    @user.save.should be_false
  end

  it 'password_digestがなければ保存できない。' do
    @user.login_name = 'foo'
    @user.display_name = 'Foo'
    @user.save.should be_false
  end

  it 'mail_addressがなければ保存できない。' do
    @user.login_name = 'foo'
    @user.display_name = 'Foo'
    @user.password_digest = 'bar'
    @user.save.should be_false
  end

  it 'arujiがなければ保存できないはず' do
    @user.login_name = 'foo'
    @user.display_name = 'Foo'
    @user.password_digest = 'bar'
    @user.mail_address = 'foo@example.com'
    @user.save.should be_false
  end
end
