# -*- encoding: utf-8 -*-

class ApplicationController < ActionController::Base
  include Jpmobile::ViewSelector
  protect_from_forgery
  clear_helpers

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

  protected

  def is_entries_page?
    false
  end
  helper_method :is_entries_page?

  private

  # カレントユーザ
  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    elsif cookies.signed[:user_id]
      id = cookies.signed[:user_id]
      token = cookies.signed[:auto_login_token]
      @current_user ||= User.where(id: id).where(auto_login_token: token).first
    end
    # androidクライアント用に、faceをクッキーに仕込む
    if @current_user
      cookies[:my_face] = @current_user.face
      if @current_user.aruji
        cookies[:aruji] = true
      else
        cookies.delete :aruji
      end
    end
    @current_user
  end
  helper_method :current_user

  def content_only
    / famn\.content_only/ =~ request.env['HTTP_USER_AGENT']
  end
  helper_method :content_only

  def logout
    session.delete :user_id
    @current_user = nil
  end

  def authenticate_user
    redirect_to [:new, :session]  if current_user.nil?
  end

  def reject_unverified_user
    redirect_to [:unverified, :account]  if current_user && (not current_user.verified?)
  end

  def set_mobile_format
    request.format = :mobile    if mobile_request? && !request.xhr?
  end

  def mobile_request?
    request.user_agent =~ /((WebKit)|(Mozilla)).+Mobile/ && !(request.user_agent =~ /iPad/)
  end
end
