# -*- encoding: utf-8 -*-

require 'spec_helper'
require 'cgi'

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
    @entry.user = User.user_by_names('sakamoto', 'ryoma')
    @entry.should_not be_valid
  end

  it '投稿日がnullではないこと' do
    @entry.message = 'dona dona 3'
    @entry.user = User.user_by_names('sakamoto', 'ryoma')
    @entry.should_not be_valid
  end

  it 'メッセージの長さが250文字以内であること' do
    @entry.message = 'a' * 251
    @entry.user = User.user_by_names('sakamoto', 'ryoma')
    @entry.posted_on = Date.today
    @entry.should_not be_valid
  end

  it '一通りそろっていればOK' do
    @entry.message = 'dona dona 3'
    @entry.user = User.user_by_names('sakamoto', 'ryoma')
    @entry.posted_on = Date.today
    @entry.save.should be_true
  end

  it '追加するとレコードが一つ増えること' do
    lambda {
      @entry.message = 'dona dona 3'
      @entry.user = User.user_by_names('sakamoto', 'ryoma')
      @entry.posted_on = Date.today
      @entry.save
    }.should change(Entry, :count).by(1)
  end
end

describe Entry, 'エントリを取り出したとき' do
  fixtures :families, :users, :entries

  before(:each) do
    user = User.user_by_names('sakamoto', 'ryoma')
    @entries = Entry.by_user(user)
  end

  it '坂本家のエントリは5件' do
    @entries.count.should eql(5)
  end

  it 'posted_onの降順になっている' do
    posted_ons = @entries.map {|e| e.posted_on}
    posted_ons.should eql(posted_ons.sort.reverse)
  end
end
