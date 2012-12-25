# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Entry, 'エントリを追加するとき' do

  before(:each) do
    # まっさらなユーザを作る
    @entry = Entry.new
  end

  describe '妥当性チェック' do

    it 'メッセージがnullではないこと' do
      @entry.should_not be_valid
    end

    it 'ユーザIDがnullではないこと' do
      @entry.message = 'dona dona'
      @entry.should_not be_valid
    end

    it '家族IDがnullではないこと' do
      @entry.message = 'dona dona'
      @entry.user_id = 1
      @entry.should_not be_valid
    end
  end
end
