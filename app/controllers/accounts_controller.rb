# -*- encoding: utf-8 -*-

class AccountsController < ApplicationController
  skip_before_filter :authenticate_user,      only: [:verify, :unverified]
  skip_before_filter :reject_unverified_user, only: [:verify, :unverified]

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
    if current_user.update_account_info(
        params[:user][:family_name],
        params[:user][:display_name],
        params[:user][:mail_address],
        params[:user][:face],
        params[:user][:current_password],
        params[:user][:new_password],
        params[:user][:new_password_confirmation]
    )
      flash.notice = 'アカウント情報を変更しました。'
    else
      flash.alert = '変更できませんでした。' + current_user.errors.to_s
    end
    redirect_to [:edit, :account]
  end

  # GET v/:id/:token
  def verify
    logout
    user = User.find(params[:id])
    if user && user.verified?
      redirect_to [:new, :session]
    elsif User.verify?(params[:id], params[:token])
      render :verified
    else
      render :not_verified
    end
  end

  # GET /account/unverified
  def unverified
    @user = current_user
    respond_to do |format|
      format.mobile
      format.html
      format.json   { head :no_content }
    end
  end
end
