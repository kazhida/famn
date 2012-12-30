# -*- encoding: utf-8 -*-

class AccountsController < ApplicationController

  # GET /account/edit
  def edit

  end

  # PUT /account/
  def update
    print "きたよ\n"
    current_user.family.display_name = params[:family_name]   if params.has_key?(:family_name)
    current_user.display_name        = params[:user_name]

    unless params[:new_password].empty?
      if current_user.authenticate(params[:current_password])
        current_user.new_password = params[:new_password]
      else
        flash.now.alert = '現在のパスワードが正しくありません。'
        render :edit
        return
      end
    end

    if current_user.save
      flash.notice = '変更しました。'
      redirect_to :action => :edit, :id => current_user.id
    else
      flash.now.alert = '変更できませんでした。'
      render :edit
    end
  end
end
