# -*- encoding: utf-8 -*-

require 'spec_helper'

describe UsersController do
  fixtures :families, :users

  describe 'ユーザを追加するとき' do

    describe '家族を増やすとき' do

      before(:each) do
        # カレントユーザを設定
        @user = User.by_names('sakamoto', 'otome')
        session[:user_id] = @user.id
      end

      it '家族を増やすとユーザが1増える' do
        expect {
          post :create, {
              login_name:   'taro',
              family_id:    @user.family_id,
              display_name: '太郎',
              mail_address: 'taro@example.com',
              aruji:        false
          }
        }.to change(User, :count).by(1)
      end

      it '名前が重複しているときは増えない' do
        expect {
          post :create, {
              login_name:   'ryoma',
              family_id:    @user.family_id,
              display_name: '龍馬',
              mail_address: 'otome@example.com',
              aruji:        false
          }
        }.to change(User, :count).by(0)
        flash.alert.present?.should be_true
      end
    end

    describe '新規登録をするとき' do

      it '新規登録をするとユーザが1増える' do
        expect {
          post :create, {
              family_login_name:    'endo',
              family_display_name:  '遠藤',
              login_name:           'taro',
              display_name:         '太郎',
              mail_address:         'taro@example.com',
              aruji:                false
          }
        }.to change(User, :count).by(1)
      end

      it '家族名が他の家族と重複していたら増えない' do
        expect {
          post :create, {
              family_login_name:    'ito',
              family_display_name:  '伊藤',
              login_name:           'taro',
              display_name:         '太郎',
              mail_address:         'taro@example.com',
              aruji:                false
          }
        }.to change(User, :count).by(0)
        flash.alert.present?.should be_true
      end
    end
  end

  describe 'ユーザを削除するとき' do

    before(:each) do
      # カレントユーザを設定
      session[:user_id] = User.by_names('sakamoto', 'otome')
    end

    it '正しいIDを指定すればユーザが1減る' do
      User.by_names('sakamoto', 'ryoma').should_not be_nil
      expect {
        delete :destroy, {
          id: User.by_names('sakamoto', 'ryoma').id
        }
      }.to change(User, :count).by(-1)
      User.by_names('sakamoto', 'ryoma').should be_nil
    end
  end
end
