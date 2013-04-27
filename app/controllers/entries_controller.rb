# -*- encoding: utf-8 -*-

class EntriesController < ApplicationController

  PER_PAGE = 10

  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry.by_user(current_user).page(params[:page]).per(PER_PAGE)
    respond_to do |format|
      format.js   { render 'entries/index_smart_phone', :layout => false}
      format.html
      format.json { render json: @entries }
    end
  end

  def reload
    @entries = Entry.by_user(current_user).page(1).per(PER_PAGE)
    respond_to do |format|
      format.js   { render 'entries/reload_smart_phone', :layout => false}
    end
  end

  # GET /entries/new
  # GET /entries/new.json
  def new
    @entry = Entry.new
    @reply_to = params[:reply_to] ? "@#{params[:reply_to]} " : ''

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
          begin
            NoticeMailer.notify(entry)  if ENV['RAILS_ENV'] == 'production'
          rescue
          end
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

  protected

  def is_entries_page?
    true
  end
end
