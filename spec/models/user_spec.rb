# -*- encoding: utf-8 -*-

require 'spec_helper'

# Userがもっているフィールドは、
#   login_name
#   display_name
#   password_digest
#   mail_address
#   aruji

describe User, 'ユーザを新規作成するとき' do

  before(:each) do
    # まっさらなユーザを作る
    @user = User.new
  end

  describe '妥当性チェック' do

    it 'login_nameがなければ保存できないはず' do
      @user.save.should be_false
    end

    it 'display_nameがなければ保存できないはず' do
      @user.login_name = 'foo'
      @user.save.should be_false
    end

    it 'password_digestがなければ保存できないはず' do
      @user.login_name = 'foo'
      @user.display_name = 'Foo'
      @user.save.should be_false
    end

    it 'mail_addressがなければ保存できないはず' do
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

    it 'passwordは6文字以上のはず' do
      @user.attributes = {
          login_name: 'foo',
          display_name: 'Foo',
          password: 'barbe',
          mail_address: 'foo@example.com',
          aruji: true
      }
      @user.save.should be_false
    end

    it 'passwordは6文字以上のはず' do
      @user.attributes = {
          login_name: 'foo',
          display_name: 'Foo',
          password: 'barboo',
          mail_address: 'foo@example.com',
          aruji: true
      }
      @user.save.should be_true
    end

    it 'login_nameはユニークなはず' do
      User.new({
          login_name: 'foo',
          display_name: 'Foo',
          password: 'barboo',
          mail_address: 'foo@example.com',
          aruji: true
      }).save
      @user.attributes = {
          login_name: 'foo',
          display_name: 'Foo2',
          password: 'barboo',
          mail_address: 'foo@example.com',
          aruji: true
      }
      @user.save.should be_false
    end

    it 'passwordを設定するとpassword_digestも設定されるはず' do
      @user.attributes = {
          login_name: 'foo3',
          display_name: 'Foo3',
          password: 'barboo',
          mail_address: 'foo@example.com',
          aruji: true
      }
      @user.save.should be_true
    end
  end
end

describe User, 'マスアサインについて' do

  before(:each) do
    # まっさらなユーザを作る
    @user = User.new
  end

  it 'password_digestはaccessibleではないはず' do
    lambda {
      @user.attributes = {
          login_name: 'foo',
          display_name: 'Foo',
          password_digest: 'bar',
          mail_address: 'foo@example.com',
          aruji: true
      }
    }.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end

  it 'passwordはaccessibleのはず' do
    lambda {
      @user.attributes = {
          login_name: 'foo',
          display_name: 'Foo',
          password: 'bar',
          mail_address: 'foo@example.com',
          aruji: true
      }
    }.should_not raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end
end
