# -*- encoding: utf-8 -*-

require 'spec_helper'

describe User, 'ユーザを新規作成するとき' do
  fixtures :families, :users

  before(:each) do
    # まっさらなユーザを作る
    @user = User.new
  end

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

  it 'family_idがなければいけない' do
    @user.login_name = 'foo'
    @user.display_name = 'Foo'
    @user.password_digest = 'bar'
    @user.mail_address = 'foo@example.com'
    @user.aruji = false
    @user.should_not be_valid
  end

  it 'passwordは6文字未満ではいけない' do
    @user.attributes = {
        login_name: 'foo2',
        display_name: 'Foo',
        password: 'barbe',
        mail_address: 'foo@example.com',
        aruji: true,
        family: Family.find_by_login_name('ito')
    }
    @user.should_not be_valid
  end

  it 'passwordは6文字以上のはず' do
    @user.attributes = {
        login_name: 'foo3',
        display_name: 'Foo',
        password: 'barboo',
        mail_address: 'foo@example.com',
        aruji: true,
        family: Family.find_by_login_name('ito')
    }
    @user.should be_valid
  end

  it 'login_nameは家族内でユニークでなければいけない' do
    @user.attributes = {
        login_name: 'hirohumi',
        display_name: 'Foo2',
        password: 'barboo',
        mail_address: 'foo@example.com',
        family: Family.find_by_login_name('ito'),
        aruji: true
    }
    @user.should_not be_valid
  end

  it 'login_nameは家族が異なれば、かぶってもOK' do
    @user.attributes = {
        login_name: 'hirohumi',
        display_name: 'Foo2',
        password: 'barboo',
        mail_address: 'foo@example.com',
        family: Family.find_by_login_name('sakamoto'),
        aruji: true
    }
    @user.should be_valid
  end

  it 'passwordを設定するとpassword_digestも設定されるはず' do
    @user.attributes = {
        login_name: 'foo3',
        display_name: 'Foo3',
        password: 'barboo',
        mail_address: 'foo@example.com',
        family: Family.find_by_login_name('ito'),
        aruji: true
    }
    @user.should be_valid
  end

  it '家族名で使われているlogin_nameは使えない' do
    @user.attributes = {
        login_name: 'sakamoto',
        display_name: 'さかもと',
        password: 'barboo',
        mail_address: 'foo@example.com',
        family: Family.find_by_login_name('ito'),
        aruji: true
    }
    @user.should_not be_valid
  end

  it '追加するとレコードが一つ増えること' do
    lambda {
      @user.attributes = {
          login_name: 'kinpachi',
          display_name: '金八',
          password: 'barboo',
          family: Family.find_by_login_name('sakamoto'),
          mail_address: 'foo@example.com',
          aruji: false
      }
      @user.save
    }.should change(User, :count).by(1)
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
