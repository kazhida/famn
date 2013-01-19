# -*- encoding: utf-8 -*-

class UsersController < ApplicationController

  # DELETE /users
  def destroy
    user_name = User.find(params[:id]).login_name
    User.delete(params[:id])
    flash[:notice] = "#{user_name}を削除しました。"
    respond_to do |format|
      format.mobile { redirect_to [:edit, :account] }
      format.html   { redirect_to [:edit, :account] }
      format.json   { head :no_content }
    end
  end
end
