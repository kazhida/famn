# -*- encoding: utf-8 -*-

require 'spec_helper'

describe AccountsController do
  fixtures :families, :users

  def valid_user_id
    User.find_by_names('sakamoto', 'ryoma').id
  end

  describe 'アカウント情報を変更するとき' do

    it '名前が変わる' do
      put :update, {
          :user_id => valid_user_id,
          :user => {
              :display_name => 'りょうま'
          }
      }
      User.find_by_names('sakamoto', 'ryoma').display_name.should == 'りょうま'
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
end
