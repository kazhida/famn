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
    @user.password_digest = 'foobar'
    @user.setting_password = true
    @user.should_not be_valid
  end

  it 'arujiがなければいけない' do
    @user.login_name = 'foo'
    @user.display_name = 'Foo'
    @user.password_digest = 'foobar'
    @user.setting_password = true
    @user.mail_address = 'foo@example.com'
    @user.should_not be_valid
  end

  it 'family_idがなければいけない' do
    @user.login_name = 'foo'
    @user.display_name = 'Foo'
    @user.password_digest = 'bar'
    @user.setting_password = true
    @user.mail_address = 'foo@example.com'
    @user.aruji = false
    @user.should_not be_valid
  end

  it 'passwordは6文字未満ではいけない' do
    @user.attributes = {
        login_name: 'foo2',
        display_name: 'Foo',
        password: 'barbe',
        setting_password: true,
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
        setting_password: true,
        mail_address: 'foo@example.com',
        aruji: true,
        family: Family.find_by_login_name('ito')
    }
    @user.should be_valid
  end

  it 'login_nameは英数字およびアンダースコア(_)のみ' do
    @user.attributes = {
        login_name: 'foo-bar2',
        display_name: 'Foo',
        password: 'barboo',
        setting_password: true,
        mail_address: 'foo@example.com',
        aruji: true,
        family: Family.find_by_login_name('ito')
    }
    @user.should_not be_valid
  end

  it 'login_nameは家族内でユニークでなければいけない' do
    @user.attributes = {
        login_name: 'hirohumi',
        display_name: 'Foo2',
        password: 'barboo',
        setting_password: true,
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
        setting_password: true,
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
        setting_password: true,
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
        setting_password: true,
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
          setting_password: true,
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

describe User, 'ユーザを探すとき' do
  fixtures :families, :users

  it '家族名とユーザ名を指定することでレコードをとってくることができる' do
    User.user_by_names('sakamoto', 'ryoma').should_not be_nil
  end

  it '家族名とユーザ名を指定することでレコードを特定できる' do
    User.user_by_names('ito', 'hirohumi').login_name.should eql('hirohumi')
  end

  it '坂本家は3人' do
    otome = User.user_by_names('sakamoto', 'otome')
    User.family_users(otome.family_id).count.should == 3
  end

  it '乙女を除くと2人' do
    otome = User.user_by_names('sakamoto', 'otome')
    User.family_users(otome.family_id, otome.id).count.should == 2
  end
end

describe User, 'ユーザを追加するとき' do

  it 'IDと認証トークンの組み合わせが正しければ認証される' do
    user = User.new_user(
        login_name: 'kinpachi',
        display_name: '金八',
        password: 'barboo',
        setting_password: true,
        family: Family.find_by_login_name('sakamoto'),
        mail_address: 'foo@example.com',
        aruji: false
    )
    user.save.should be_true
    User.verify(user.id, user.verification_token).should be_true
  end

  it '認証トークンが違っていたら認証されない' do
    user = User.new_user(
        login_name: 'kinpachi',
        display_name: '金八',
        password: 'barboo',
        setting_password: true,
        family: Family.find_by_login_name('sakamoto'),
        mail_address: 'foo@example.com',
        aruji: false
    )
    user.save.should be_true
    User.verify(user.id, user.verification_token + 's').should be_false
  end

  it '10人までは追加できる' do
    user = User.new_user(
        login_name: 'juro',
        display_name: '十朗',
        password: 'barboo',
        setting_password: true,
        family: Family.find_by_login_name('ito'),
        mail_address: 'foo@example.com',
        aruji: false
    )
    user.save.should be_true
  end

  it '11人目は追加できない' do
    user = User.new_user(
        login_name: 'juro',
        display_name: '十朗',
        password: 'barboo',
        setting_password: true,
        family: Family.find_by_login_name('ito'),
        mail_address: 'foo@example.com',
        aruji: false
    )
    user.save.should be_true
    User.family_users(2).count.should == 10
    user = User.new_user(
        login_name: 'juichiro',
        display_name: '十一朗',
        password: 'barboo',
        setting_password: true,
        family: Family.find_by_login_name('ito'),
        mail_address: 'foo@example.com',
        aruji: false
    )
    user.save.should_not be_true
  end
end