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

  it 'family_idがなければいけない' do
    @user.login_name = 'foo'
    @user.should_not be_valid
  end

  it 'display_nameがなければいけない' do
    @user.login_name = 'foo'
    @user.family     = Family.find_by_login_name('ito')
    @user.should_not be_valid
  end


  it 'password_digestがなければいけない' do
    @user.login_name = 'foo'
    @user.family     = Family.find_by_login_name('ito')
    @user.display_name = 'Foo'
    @user.should_not be_valid
  end

  it 'mail_addressがなければいけない' do
    @user.login_name = 'foo'
    @user.family     = Family.find_by_login_name('ito')
    @user.display_name = 'Foo'
    @user.password_digest = 'foobar'
    @user.setting_password = true
    @user.should_not be_valid
  end

  it 'arujiがなければいけない' do
    @user.login_name = 'foo'
    @user.family     = Family.find_by_login_name('ito')
    @user.display_name = 'Foo'
    @user.password_digest = 'foobar'
    @user.setting_password = true
    @user.mail_address = 'foo@example.com'
    @user.aruji = nil
    @user.should_not be_valid
  end

  it 'passwordは6文字未満ではいけない' do
    @user.attributes = {
        login_name: 'foo2',
        family:      Family.find_by_login_name('ito'),
        display_name: 'Foo',
        password: 'barbe',
        setting_password: true,
        mail_address: 'foo@example.com',
        aruji: true
    }
    @user.should_not be_valid
  end

  it 'passwordは6文字以上のはず' do
    @user.attributes = {
        login_name: 'foo3',
        family:      Family.find_by_login_name('ito'),
        display_name: 'Foo',
        password: 'barboo',
        setting_password: true,
        mail_address: 'foo@example.com',
        aruji: true
    }
    @user.should be_valid
  end

  it 'login_nameは英数字およびアンダースコア(_)のみ' do
    @user.attributes = {
        login_name: 'foo-bar2',
        family:      Family.find_by_login_name('ito'),
        display_name: 'Foo',
        password: 'barboo',
        setting_password: true,
        mail_address: 'foo@example.com',
        aruji: true
    }
    @user.should_not be_valid
  end

  it 'login_nameは家族内でユニークでなければいけない' do
    @user.attributes = {
        login_name: 'hirohumi',
        family: Family.find_by_login_name('ito'),
        display_name: 'Foo2',
        password: 'barboo',
        setting_password: true,
        mail_address: 'foo@example.com',
        aruji: true
    }
    @user.should_not be_valid
  end

  it 'login_nameは家族が異なれば、かぶってもOK' do
    @user.attributes = {
        login_name: 'hirohumi',
        family: Family.find_by_login_name('sakamoto'),
        display_name: 'Foo2',
        password: 'barboo',
        setting_password: true,
        mail_address: 'foo@example.com',
        aruji: true
    }
    @user.should be_valid
  end

  it 'passwordを設定するとpassword_digestも設定されるはず' do
    @user.attributes = {
        login_name: 'foo3',
        family: Family.find_by_login_name('ito'),
        display_name: 'Foo3',
        password: 'barboo',
        setting_password: true,
        mail_address: 'foo@example.com',
        aruji: true
    }
    @user.should be_valid
  end

  it '家族名で使われているlogin_nameは使えない' do
    @user.attributes = {
        login_name: 'sakamoto',
        family: Family.find_by_login_name('ito'),
        display_name: 'さかもと',
        password: 'barboo',
        setting_password: true,
        mail_address: 'foo@example.com',
        aruji: true
    }
    @user.should_not be_valid
  end

  it '追加するとレコードが一つ増えること' do
    lambda {
      @user.attributes = {
          login_name: 'kinpachi',
          family: Family.find_by_login_name('sakamoto'),
          display_name: '金八',
          password: 'barboo',
          setting_password: true,
          mail_address: 'foo@example.com',
          aruji: false
      }
      @user.save
    }.should change(User, :count).by(1)
  end


  it '保存時にauto_login_tokenが割り当てられていること' do
    @user.attributes = {
        login_name: 'kinpachi',
        family: Family.find_by_login_name('sakamoto'),
        display_name: '金八',
        password: 'barboo',
        setting_password: true,
        mail_address: 'foo@example.com',
        aruji: false
    }
    @user.save.should be_true
    @user.auto_login_token.should_not be_nil
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
    User.by_names('sakamoto', 'ryoma').should_not be_nil
  end

  it '家族名とユーザ名を指定することでレコードを特定できる' do
    User.by_names('ito', 'hirohumi').login_name.should eql('hirohumi')
  end

  it '坂本家は3人' do
    otome = User.by_names('sakamoto', 'otome')
    User.family_users(otome.family_id).count.should == 3
  end

  it '乙女を除くと2人' do
    otome = User.by_names('sakamoto', 'otome')
    User.family_users(otome.family_id, otome.id).count.should == 2
  end
end

describe User, 'ユーザを追加するとき' do
  fixtures :families, :users

  it 'IDと認証トークンの組み合わせが正しければ認証される' do
    user = User.add_new_user(
        'kinpachi',
        '金八',
        'foo@example.com',
        false,
        Family.find_by_login_name('sakamoto')
    )
    user.should_not be_nil
    User.verify?(user.id, user.verification_token).should be_true
  end

  it '認証トークンが違っていたら認証されない' do
    user = User.add_new_user(
        'kinpachi',
        '金八',
        'foo@example.com',
        false,
        Family.find_by_login_name('sakamoto')
    )
    user.should_not be_nil
    User.verify?(user.id, user.verification_token + 's').should be_false
  end

  it 'テスト開始時の伊藤家は9人' do
    User.where('family_id = 2').count.should == 9
  end

  it '10人までは追加できる' do
    User.add_new_user(
        'juro',
        '十朗',
        'foo@example.com',
        false,
        Family.find_by_login_name('ito'),
        'barboo'
    ).should_not be_nil
  end

  it '11人目は追加できない' do
    User.add_new_user(
        'juro',
        '十朗',
        'foo@example.com',
        false,
        Family.find_by_login_name('ito'),
        'barboo'
    ).should_not be_nil
    User.family_users(2).count.should == 10
    User.add_new_user(
        'juichiro',
        '十一朗',
        'foo@example.com',
        false,
        Family.find_by_login_name('ito')
    ).should be_nil
  end

  it '家族名を指定したときは家族が作られる' do
    user = User.add_new_user(
        'kinpachi',
        '金八',
        'foo@example.com',
        false,
        {
            login_name: 'hashimoto',
            display_name: '橋本'
        }
    )
    user.should_not be_nil
    Family.all.count.should == 3
    Family.find(user.family_id).should_not be_nil
  end
end

describe User, 'ユーザ情報を更新するとき' do
  fixtures :families, :users

  before(:each) do
    @user = User.by_names('sakamoto', 'otome')
    @user.password_digest = BCrypt::Password.create('foobar')
    @user.save
  end

  it 'パスワード更新がなければ、名前だけ変わる' do
    @user.update_account_info('さかもと', 'おとめ', 'otome@example.com', :red).should be_true

    @user = User.by_names('sakamoto', 'otome')
    @user.family_name.should == 'さかもと'
    @user.display_name.should == 'おとめ'
  end

  it '家族名がnilなら、家族名は変わらない' do
    @user.update_account_info(nil, 'おとめ', 'otome@example.com', :red).should be_true

    @user = User.by_names('sakamoto', 'otome')
    @user.family_name.should == '坂本'
    @user.display_name.should == 'おとめ'
  end

  it 'パスワードを変えるときは、現在のパスワードも必要' do
    @user.update_account_info('さかもと', 'おとめ', 'otome@example.com', :red, nil, 'hogehoge').should be_false

    @user = User.by_names('sakamoto', 'otome')
    @user.family_name.should == '坂本'
    @user.display_name.should == '乙女'
  end

  it 'パスワードを変えるときは、現在のパスワードとconfirmが必要' do
    @user.update_account_info('さかもと', 'おとめ', 'otome@example.com', :red, 'foobar', 'hogehoge', 'fugafuga').should be_false

    @user = User.by_names('sakamoto', 'otome')
    @user.family_name.should == '坂本'
    @user.display_name.should == '乙女'
  end

  it 'パスワードを更新するときは、現在のパスワードと、confirmationもあれば、OK' do
    @user.update_account_info('さかもと', 'おとめ', 'otome@example.com', :red, 'foobar', 'hogehoge', 'hogehoge').should be_true

    @user = User.by_names('sakamoto', 'otome')
    @user.family_name.should == 'さかもと'
    @user.display_name.should == 'おとめ'
  end
end