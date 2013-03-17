# -*- encoding: utf-8 -*-

class SessionsController < ApplicationController
  skip_before_filter :authenticate_user
  skip_before_filter :reject_unverified_user

  def new
    respond_to do |format|
      format.html
      format.json { head 200 }
    end
  end

  # POST /sessions
  # POST /sessions.json
  def create
    user = User.authenticated_user(params[:family_name], params[:user_name], params[:password])

    if user
      session[:user_id] = user.id
      unless params[:family_name] == 'visitor'
        if params[:remember_me]
          cookies.permanent.signed[:user_id] = user.id
          cookies.permanent.signed[:auto_login_token] = user.auto_login_token
        end
      end
      flash.notice = 'ログインしました。'
      respond_to do |format|
        format.html   { redirect_to :root }
        format.json   { head 201 }
      end
    else
      flash.alert = 'ログイン名またはパスワードが正しくありません。'
      respond_to do |format|
        format.html   { redirect_to :root }
        format.json   { head 401 }
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    session.delete :user_id
    cookies.delete :user_id
    cookies.delete :auto_login_token
    respond_to do |format|
      format.html   { redirect_to :root }
      format.json   { head :no_content }
    end
  end
end
