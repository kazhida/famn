# -*- encoding: utf-8 -*-

class UsersController < ApplicationController
  skip_before_filter :authenticate_user,      only: [:index, :show, :new, :create]
  skip_before_filter :reject_unverified_user, only: [:index, :show, :new, :create]

  # GET /users
  def index
    @users = User.by_family_id(current_user.family_id)
    respond_to do |format|
      format.mobile
      format.html
      format.json   { render json: @users}
    end
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.mobile
      format.html
      format.json   { render json: @user}
    end
  end

  # GET /users/new
  def new
  end

  # POST /users
  def create
    family = current_user ? current_user.family : {
        :login_name => params[:family_login_name],
        :display_name => params[:family_display_name]
    }
    user = User.add_new_user(params[:login_name],
                             params[:display_name],
                             params[:mail_address],
                             params[:aruji],
                             family)
    if user
      AccountMailer.email_verification(current_user, user).deliver
      flash.notice = '確認メールを送信しました。'
    else
      flash.alert  = 'ユーザを作成できませんでした。原因としては、ユーザ名の重複やメールアドレスの間違いなどが考えられます。'
    end
    if current_user.nil?
      redirect_to :controller => :users, :action => :new
    else
      redirect_to :controller => :accounts, :action => :edit
    end
  end

  # DELETE /users
  def destroy
    user_name = User.find(params[:id]).login_name
    User.delete(params[:id])
    flash[:notice] = "#{user_name}を削除しました。"
    respond_to do |format|
      format.mobile { redirect_to :controller => :accounts, :action => :edit }
      format.html   { redirect_to :controller => :accounts, :action => :edit }
      format.json   { head :no_content }
    end
  end
end
