# -*- encoding: utf-8 -*-

class UsersController < ApplicationController
  skip_before_filter :authenticate_user, :only => [:verify]
  skip_before_filter :reject_unverified_user, :only => [:verify]

  # GET /users/new
  def new
  end

  # POST /users
  def create
    @user = User.new_user(
      login_name:   params[:user_name],
      display_name: params[:user_name],
      password:     SecureRandom.hex[0...8],
      setting_password: true,
      mail_address: params[:user_name],
      aruji:        params.has_key?(:aruji),
      family:       current_user.family
    )
    if @user.save
      AccountMailer.email_verification(current_user, @user).deliver
      flash.notice = '確認メールを送信しました。'
    else
      flash.alert  = 'ユーザを作成できませんでした。原因としては、ユーザ名の重複やメールアドレスの間違いなどが考えられます。'
    end
    redirect_to [:edit, :account]
  end

  # DELETE /users
  def destroy
    User.delete(params[:id])
    respond_to do |format|
      format.mobile { redirect_to [:edit, :account] }
      format.html   { redirect_to [:edit, :account] }
      format.json   { head :no_content }
    end
  end

  def verify
    if User.verify(params[:id], params[:token])
      render :verified
    else
      render :not_verified
    end
  end
end
