# -*- encoding: utf-8 -*-

class AccountsController < ApplicationController
  skip_before_filter :authenticate_user

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
    #current_user.attributes = params[:user]
    #current_user.changing_password = true   unless current_user.new_password.empty?

    if current_user.update_account_info(
        params[:user][:family_name],
        params[:user][:display_name],
        params[:user][:current_password],
        params[:user][:new_password],
        params[:user][:new_password_confirmation]
    )
      flash.notice = 'アカウント情報を変更しました。'
      redirect_to [:edit, :account]
    else
      flash.alert = '変更できませんでした。' + "#{current_user.inspect}" + "#{params} + #{current_user.errors.to_s}"
      redirect_to [:edit, :account]
    end
  end
end
