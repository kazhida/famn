# -*- encoding: utf-8 -*-

class SessionsController < ApplicationController
  skip_before_filter :authenticate_user

  # POST /sessions
  # POST /sessions.json
  def create
    user = User.find_by_names(params[:family_name], params[:user_name])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash.notice = 'ログインしました。'
      respond_to do |format|
        format.html {redirect_to :root}
        format.json { head 201 }
      end
    else
      flash.now.alert = 'ログイン名またはパスワードが正しくありません。'
      respond_to do |format|
        format.html { render :new}
        format.json { head 401 }
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    session.delete :user_id
    respond_to do |format|
      format.html { redirect_to [:new, :session] }
      format.json { head :no_content }
    end
  end
end
