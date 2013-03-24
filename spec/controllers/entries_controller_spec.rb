# -*- encoding: utf-8 -*-

require 'spec_helper'

describe EntriesController do
  fixtures :families, :users, :neighborhoods

  describe 'ポストするとき' do

    def valid_user_id
      User.by_names('sakamoto', 'ryoma').id
    end

    before(:each) do
      session[:user_id] = valid_user_id
    end

    describe 'うまくいくパターン' do

      it '普通にポストすると1増える' do
        expect {
          post :create, {
            :message   => 'MyText',
            :face      => 1,
          }
        }.to change(Entry, :count).by(1)
      end

      it '宛先付きでポストすると1増える' do
        expect {
          post :create, {
              :message   => '@hida @ryoma @kyu いくよ。',
              :face      => 1,
          }
        }.to change(Entry, :count).by(1)
      end

      it '宛先を指定すると、それを切り出してくれる' do
        post :create, {
            :message   => '@hida @ryoma @kyu いくよ。',
            :face      => 1,
        }
        assigns(:entry).should be_a(Entry)
        assigns(:entry).should be_persisted
        dests = assigns(:entry).destinations
        #dests.length.should == 3
        dests[0].should == 'hida'
        dests[1].should == 'ryoma'
        dests[2].should == 'kyu'
        dests[3].should be_nil
      end

      it '宛先を指定すると、宛先レコードが増える' do
        expect {
          post :create, {
              :message   => '@ito @ryoma @kyu いくよ。',
              :face      => 1,
          }
        }.to change(Destination, :count).by(3)
      end

      it 'ポストした後、一覧画面に戻る' do
        post :create, {
            :message   => 'MyText',
            :face      => 1,
        }
        response.should redirect_to(:root)
      end
    end
  end

  describe 'ご近所さん管理' do

    def family_id(family_name)
      Family.find_by_login_name(family_name).id
    end

    before(:each) do
      session[:user_id] = User.by_names('sakamoto', 'ryoma').id
    end

    it '家族名を宛先に指定すると、ご近所レコードが増える' do
      expect {
        post :create, {
            :message   => '@ito いくよ。',
            :face      => 1,
        }
        response.should redirect_to(:root)
      }.to change(Neighborhood, :count).by(1)
    end

    it '家族名を宛先に指定すると、宛先のご近所レコードが増える' do
      expect {
        post :create, {
            :message   => '@ito いくよ。',
            :face      => 1,
        }
        response.should redirect_to(:root)
      }.to change(Neighborhood.neighborhood_of(family_id('ito')), :count).by(1)
    end

    it '家族名でなければ増えない' do
      expect {
        post :create, {
            :message   => '@ryoma @kyu いくよ。',
            :face      => 1,
        }
      }.to change(Neighborhood, :count).by(0)
    end
  end
end
