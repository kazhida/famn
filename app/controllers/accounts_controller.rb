# -*- encoding: utf-8 -*-

class AccountsController < ApplicationController
  skip_before_filter :authenticate_user, :only      => [:verify, :unverified]
  skip_before_filter :reject_unverified_user, :only => [:verify, :unverified]

  def back_to_edit
    redirect_to [:edit, :account]
  end

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
    else
      flash.alert = '変更できませんでした。' + "#{current_user.inspect}" + "#{params} + #{current_user.errors.to_s}"
    end
    back_to_edit
  end

  # GET /account/new
  def new
  end

  # POST /account
  def create
    @user = User.new_user(
        login_name:   params[:login_name],
        display_name: params[:display_name],
        password:     SecureRandom.hex(4),
        setting_password: true,
        mail_address: params[:mail_address],
        aruji:        params.has_key?(:aruji) && params[:aruji],
        family:       current_user.family
    )
    if @user.save
      AccountMailer.email_verification(current_user, @user).deliver
      flash.notice = '確認メールを送信しました。'
    else
      flash.alert  = 'ユーザを作成できませんでした。原因としては、ユーザ名の重複やメールアドレスの間違いなどが考えられます。'
    end
    back_to_edit
  end

  # DELETE /account
  def destroy
    user = User.find(params[:delete_id]).login_name
    User.delete(params[:delete_id])
    flash[:notice] = "#{user}を削除しました。"
    respond_to do |format|
      format.mobile { back_to_edit }
      format.html   { back_to_edit }
      format.json   { head :no_content }
    end
  end

  # POST /account/remove_user
  def remove_user
    user = User.find(params[:delete_id]).login_name
    User.delete(params[:delete_id])
    flash[:notice] = "#{user}を削除しました。"
    respond_to do |format|
      format.mobile { back_to_edit }
      format.html   { back_to_edit }
      format.json   { head :no_content }
    end
  end

  #def link_to_delete(user)
  #  link_to :account, :confirm => '本当に削除しますか?', :method =>:delete, :delete_id => user.id
  #end
  #helper_method :link_to_delete

  # GET v/:id/:token
  def verify
    logout
    if User.verify(params[:id], params[:token])
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
