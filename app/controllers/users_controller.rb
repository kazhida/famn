# -*- encoding: utf-8 -*-

class UsersController < ApplicationController

  # GET /account/new
  def new
  end

  # POST /account
  def create
    @user = User.new
    @user.attributes = {
        login_name:   params[:user_name],
        display_name: params[:user_name],
        password:     'barboo',
        setting_password: true,
        mail_address: params[:user_name],
        aruji:        params.has_key?(:aruji),
        family:       current_user.family
    }
    if @user.save
      AccountMailer.email_verification(@user).deliver
      flash.notice = '確認メールを送信しました。'
    else
      flash.alert  = 'ユーザを作成できませんでした。原因としては、ユーザ名の重複やメールアドレスの間違いなどが考えられます。'
    end
    redirect_to [:edit, :account]
  end

  # DELETE /account
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.mobile { redirect_to [:edit, :account] }
      format.html   { redirect_to [:edit, :account] }
      format.json   { head :no_content }
    end
  end
end
