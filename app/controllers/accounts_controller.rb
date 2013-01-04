# -*- encoding: utf-8 -*-

class AccountsController < ApplicationController
  skip_before_filter :authenticate_user, :only => [:new, :create]

  # GET /account/edit
  def edit
    respond_to do |format|
      format.mobile
      format.html
      format.json   { head :no_content }
    end
  end

  # PUT /account
  def update
    current_user.attributes = params[:user]
    current_user.changing_password = true   unless current_user.new_password.empty?

    if current_user.save
      flash.now.notice = 'アカウント情報を変更しました。'
      render :edit
    else
      flash.now.alert = '変更できませんでした。' + "#{current_user.inspect}" + "#{params}"
      render :edit
    end
  end
end
