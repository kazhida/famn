# -*- encoding: utf-8 -*-

require 'spec_helper'

describe SessionsController do

  describe 'ログインするとき' do

    before(:each) do
      user = User.user_by_names('sakamoto', 'ryoma')
      user.password = 'foobar'
      user.save!
    end

    it '正しい名前とパスワードでログインできる' do
      post :create, {
          :family_name => 'sakamoto',
          :user_name   => 'ryoma',
          :password    => 'foobar'
      }
      response.should redirect_to(:controller => :entries, :action => :index)
    end

    it 'パスワードが間違ってるとログインできない' do
      post :create, {
          :family_name => 'sakamoto',
          :user_name => 'ryoma',
          :password => 'fooboo'
      }
      response.should render_template(:controller => :sessions, :action => :new)
    end
  end
end
