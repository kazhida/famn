class SessionsController < ApplicationController
  skip_before_filter :authenticate_user

  # POST /entries
  # POST /entries.json
  def create
    user = User.find_by_names(params[:family_name], params[:user_name])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      respond_to do |format|
        format.html {redirect_to :root}
        format.json { head 201 }
      end
    else
      respond_to do |format|
        format.html { render :new}
        format.json { head 401 }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    session.delete :user_id
    respond_to do |format|
      format.html { redirect_to [:new, :session] }
      format.json { head :no_content }
    end
  end
end
