# -*- encoding: utf-8 -*-

class EntriesController < ApplicationController
  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry.by_user(current_user).page(params[:page]).per(12)

    respond_to do |format|
      format.mobile
      format.html # index.html.slim
      format.json { render json: @entries }
    end
  end

  # GET /entries/new
  # GET /entries/new.json
  def new
    @entry = Entry.new
    @send_to = params[:send_to] ? "@#{params[:send_to]} " : ''

    respond_to do |format|
      format.mobile
      format.html # new.html.slim
      format.json { render json: @entry }
    end
  end

  # POST /entries
  # POST /entries.json
  def create
    #@entry = Entry.new
    #@entry.message   = params[:message]
    #@entry.user      = current_user
    #@entry.family    = current_user.family
    #@entry.posted_on = DateTime.now

    respond_to do |format|
      if Entry.post(current_user, params[:message])  #@entry.save
        format.mobile { redirect_to :entries }
        format.html   { redirect_to :entries }
        format.json   { render json: @entry, status: :created, location: @entry }
      else
        format.mobile { render action: 'new', alert: '書き込めませんでした。' }
        format.html   { render action: 'new', alert: '書き込めませんでした。' }
        format.json   { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    Entry.delete(params[:id])
    respond_to do |format|
      format.mobile { redirect_to entries_url }
      format.html   { redirect_to entries_url }
      format.json   { head :no_content }
    end
  end

  private

  def list_item(entry)
    render_to_string :partial => 'shared/entry_list_item', :locals => {entry: entry}
  end
  helper_method :list_item
end
