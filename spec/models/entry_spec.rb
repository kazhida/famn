# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Entry, 'エントリを追加するとき' do
  fixtures :families, :users, :entries

  before(:each) do
    # まっさらなユーザを作る
    @entry = Entry.new
  end

  it 'メッセージがnullではないこと' do
    @entry.should_not be_valid
  end

  it 'ユーザがnullではないこと' do
    @entry.message = 'dona dona'
    @entry.should_not be_valid
  end

  it '家族がnullではないこと' do
    @entry.message = 'dona dona 2'
    @entry.user = User.find_by_login_name('ryoma')
    @entry.should_not be_valid
  end

  it '投稿日がnullではないこと' do
    @entry.message = 'dona dona 3'
    @entry.user = User.find_by_login_name('ryoma')
    @entry.family = User.find_by_login_name('sakamoto')
    @entry.should_not be_valid
  end

  it '追加するとレコードが一つ増えること' do
    lambda {
      @entry.message = 'dona dona 3'
      @entry.user = User.find_by_login_name('ryoma')
      @entry.family = Family.find_by_login_name('sakamoto')
      @entry.posted_on = Date.today
      @entry.save
    }.should change(Entry, :count).by(1)
  end
end
