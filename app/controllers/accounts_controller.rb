class AccountsController < ApplicationController



  def update
    current_user.family.display_name = params[:family_name]   if params.has_key?(:family_name)
    current_user.display_name        = params[:user_name]

    if current_user.save
      redirect_to :account
    else
      render :show
    end
  end
end
