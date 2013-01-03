# -*- encoding: utf-8 -*-

class InfosController < ApplicationController
  skip_before_filter :authenticate_user

  def about
    render :about
  end

  def privacy_policy
  end
end
