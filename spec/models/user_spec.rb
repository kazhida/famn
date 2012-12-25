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

    it 'login_nameがなければいけない' do
      @user.should_not be_valid
    end

    it 'display_nameがなければいけない' do
      @user.login_name = 'foo'
      @user.should_not be_valid
    end

    it 'password_digestがなければいけない' do
      @user.login_name = 'foo'
      @user.display_name = 'Foo'
      @user.should_not be_valid
    end

    it 'mail_addressがなければいけない' do
      @user.login_name = 'foo'
      @user.display_name = 'Foo'
      @user.password_digest = 'bar'
      @user.should_not be_valid
    end

    it 'arujiがなければいけない' do
      @user.login_name = 'foo'
      @user.display_name = 'Foo'
      @user.password_digest = 'bar'
      @user.mail_address = 'foo@example.com'
      @user.should_not be_valid
    end

    it 'passwordは6文字未満ではいけない' do
      @user.attributes = {
          login_name: 'foo',
          display_name: 'Foo',
          password: 'barbe',
          mail_address: 'foo@example.com',
          aruji: true
      }
      @user.should_not be_valid
    end

    it 'passwordは6文字以上のはず' do
      @user.attributes = {
          login_name: 'foo',
          display_name: 'Foo',
          password: 'barboo',
          mail_address: 'foo@example.com',
          aruji: true
      }
      @user.should be_valid
    end

    it 'login_nameはユニークでなければいけない' do
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
      @user.should_not be_valid
    end

    it 'passwordを設定するとpassword_digestも設定されるはず' do
      @user.attributes = {
          login_name: 'foo3',
          display_name: 'Foo3',
          password: 'barboo',
          mail_address: 'foo@example.com',
          aruji: true
      }
      @user.should be_valid
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
