class EntriesController < ApplicationController
  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry.find_by_user(current_user)

    respond_to do |format|
      format.html # index.html.slim
      format.json { render json: @entries }
    end
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    @entry = Entry.find_by_user(current_user).find(params[:id])

    respond_to do |format|
      format.html # show.html.slim
      format.json { render json: @entry }
    end
  end

  # GET /entries/new
  # GET /entries/new.json
  def new
    @entry = Entry.new

    respond_to do |format|
      format.html # new.html.slim
      format.json { render json: @entry }
    end
  end

  # GET /entries/1/edit
  #def edit
  #  @entry = current_user.entries.find(params[:id])
  #end

  # POST /entries
  # POST /entries.json
  def create
    @entry = Entry.new(params[:entry])
    @entry.user   = current_user
    @entry.family = current_user.family

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Entry was successfully created.' }
        format.json { render json: @entry, status: :created, location: @entry }
      else
        format.html { render action: "new" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /entries/1
  # PUT /entries/1.json
  #def update
  #  @entry = current_user.entries.find(params[:id])
  #
  #  respond_to do |format|
  #    if @entry.update_attributes(params[:entry])
  #      format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @entry.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry = current_user.entries.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to entries_url }
      format.json { head :no_content }
    end
  end
end
