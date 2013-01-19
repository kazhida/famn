# -*- encoding: utf-8 -*-

class ApplicationController < ActionController::Base
  protect_from_forgery
  clear_helpers

  before_filter :set_mobile_format
  before_filter :authenticate_user
  before_filter :reject_unverified_user

  private

  # カレントユーザ
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
    end
  end
  helper_method :current_user

  def logout
    session.delete :user_id
    @current_user = nil
  end

  def authenticate_user
    redirect_to [:new, :session]  unless current_user
  end

  def reject_unverified_user
    redirect_to [:unverified, :account] unless (not current_user.nil?) && current_user.verified?
  end

  def set_mobile_format
    request.format = :mobile  if mobile_request?
  end

  def mobile_request?
    request.user_agent =~ /(WebKit.+Mobile)/
  end
end
