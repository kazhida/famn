# -*- encoding: utf-8 -*-

class ApplicationController < ActionController::Base
  protect_from_forgery
  clear_helpers

  before_filter :set_mobile_format
  before_filter :authenticate_user
  before_filter :reject_unverified_user

  rescue_from ActionController::RoutingError,
              ActiveRecord::RecordNotFound,
              :with => :render_404
  rescue_from Exception,
              :with => :render_500

  def log_exception(code, exception)
    logger.info "Rendering #{code} with exception: #{exception.message}"
  end

  def render_500(exception = nil)
    log_exception 500, exception    if exception
    render 'errors/500',  :status => 500
  end

  def render_404(exception = nil)
    log_exception 404, exception    if exception
    render 'errors/404', :status => 404
  end

  private

  # カレントユーザ
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
    elsif cookies.signed[:user_id]
      id = cookies.signed[:user_id]
      token = cookies.signed[:auto_login_token]
      @current_user ||= User.find_by_id_and_auto_login_token(id, token)
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
    redirect_to [:unverified, :account]  if current_user && (not current_user.verified?)
  end

  def set_mobile_format
    request.format = :mobile  if mobile_request?
  end

  def mobile_request?
    request.user_agent =~ /((WebKit)|(Mozilla)).+Mobile/ && !(request.user_agent =~ /iPad/)
  end
end
