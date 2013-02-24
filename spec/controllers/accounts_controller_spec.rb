# -*- encoding: utf-8 -*-

require 'spec_helper'

describe AccountsController do
  fixtures :families, :users

  describe 'アカウント情報を変更するとき' do

    def valid_user_id
      User.by_names('sakamoto', 'ryoma').id
    end

    before(:each) do
      session[:user_id] = valid_user_id
    end

    it '名前が変わる' do
      put :update, {
          :user => {
              :family_name => nil,
              :display_name => 'りょうま',
              :mail_address => 'ryoma@example.com',
              :face => 'gray'
          }
      }
      User.by_names('sakamoto', 'ryoma').display_name.should == 'りょうま'
    end

    it 'パスワードを変更する場合は、現在のパスワードも入力する必要がある' do
      put :update, {
          :user_id => valid_user_id,
          :user => {
              :display_name => 'りょうま',
              :new_password => 'hogehoge'
          }
      }
      flash.alert.present?.should be_true
    end
  end

  describe '本人確認メールの認証を行うとき' do

    before(:each) do
      # 未認証状態にする
      @user = User.by_names('sakamoto', 'ryoma')
      @user.verification_token = '01234567abcdef'
      @user.save!
    end

    it '正しいURLなら完了ページが表示される' do
      get :verify, id: @user.id, token: @user.verification_token
      response.should render_template('accounts/verified')
    end

    it '間違ったURLの場合、それを示すページが表示される' do
      get :verify, {
          id: @user.id,
          token: 'f00ba2ba2227d9021f46a7d8fa79b6ed'
      }
      response.should render_template('accounts/not_verified')
    end
  end
end
