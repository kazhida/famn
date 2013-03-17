# -*- encoding: utf-8 -*-

class EntriesController < ApplicationController
  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry.by_user(current_user).page(params[:page]).per(12)
    @mobile  = mobile_request?
    respond_to do |format|
      format.js
      format.html
      format.json { render json: @entries }
    end
  end

  # GET /entries/new
  # GET /entries/new.json
  def new
    @entry = Entry.new
    @send_to = params[:send_to] ? "@#{params[:send_to]} " : ''

    respond_to do |format|
      format.html # new.html.slim
      format.json { render json: @entry }
    end
  end

  # POST /entries
  # POST /entries.json
  def create
    respond_to do |format|
      begin
        Entry.post!(current_user, params[:message], params[:face]) do |entry|
          @entry = entry
          NoticeMailer.notify(entry)  if ENV['RAILS_ENV'] == 'production'
        end
        format.html   { redirect_to :root }
        format.json   { render json: @entry, status: :created, location: @entry }
      rescue
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
      format.html   { redirect_to entries_url }
      format.json   { head :no_content }
    end
  end
end
