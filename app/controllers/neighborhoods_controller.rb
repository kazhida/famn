class NeighborhoodsController < ApplicationController

  def show
    @neighborhood = Neighborhood.find(params[:id])
    respond_to do |format|
      format.html
      format.json   { render json: @neighborhood}
    end
  end

  def change_flags
    @neighborhood = Neighborhood.find(params[:id])
    yield @neighborhood
    respond_to do |format|
      format.js     { render js: @neighborhood, layout: false}
      format.html   { redirect_to :back}
      format.json   { head :no_content }
    end
  end

  def accept
    change_flags do |n|
      n.accept
    end
  end

  def reject
    change_flags do |n|
      n.reject
    end
  end

  def suspend
    change_flags do |n|
      n.suspend
    end
  end
end
