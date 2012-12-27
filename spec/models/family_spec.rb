# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Family, '新規作成するとき' do
  fixtures :families, :users

  before(:each) do
    # まっさらな家族を作る
    @family = Family.new
  end

  it 'login_nameがなければいけない' do
    @family.should_not be_valid
  end

  it 'display_nameがなければいけない' do
    @family.login_name = 'foo'
    @family.should_not be_valid
  end

  it 'login_nameとdisplay_nameがそろっていればOK' do
    @family.login_name = 'foo'
    @family.display_name = 'ななし'
    @family.should be_valid
  end

  it 'login_nameは英数字およびアンダースコア(_)のみ' do
    @family.login_name = 'foo-bar-2'
    @family.display_name = 'ななし'
    @family.should_not be_valid
  end

  it '使用されている名前は使えない' do
    @family.attributes = {
      login_name: 'ito',
      display_name: 'さかもろ'
    }
    @family.should_not be_valid
  end

  it 'ユーザのログイン名に使われている名前は使えない' do
    @family.attributes = {
        login_name: 'otome',
        display_name: 'おとめ'
    }
    @family.should_not be_valid
  end

  it '追加するとレコードが一つ増えること' do
    lambda {
      @family.attributes = {
          login_name: 'takasugi',
          display_name: '高杉'
      }
      @family.save
    }.should change(Family, :count).by(1)
  end
end
