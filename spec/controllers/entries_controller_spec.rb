require 'spec_helper'

describe EntriesController do
  fixtures :families, :users

  # This should return the minimal set of attributes required to create a valid
  # Entry. As you add validations to Entry, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
        :message   => 'MyText',
        :family    => Family.find_by_login_name('sakamoto'),
        :user      => User.find_by_login_name('ryoma'),
        :posted_on => DateTime.now
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EntriesController. Be sure to keep this updated too.
  def valid_session
    {
        :family_name => 'sakamoto',
        :user_name => 'ryoma',
        :password => 'foobar'
    }
  end

  #describe 'GET index' do
  #  it 'assigns all entries as @entries' do
  #    entry = Entry.create! valid_attributes
  #    get :index, {}, valid_session
  #    assigns(:entries).should eq([entry])
  #  end
  #end
  #
  #describe 'GET new' do
  #  it 'assigns a new entry as @entry' do
  #    get :new, {}, valid_session
  #    assigns(:entry).should be_a_new(Entry)
  #  end
  #end
  #
  #describe 'POST create' do
  #  describe 'with valid params' do
  #    it 'creates a new Entry' do
  #      expect {
  #        post :create, {:entry => valid_attributes}, valid_session
  #      }.to change(Entry, :count).by(1)
  #    end
  #
  #    it 'assigns a newly created entry as @entry' do
  #      post :create, {:entry => valid_attributes}, valid_session
  #      assigns(:entry).should be_a(Entry)
  #      assigns(:entry).should be_persisted
  #    end
  #
  #    it 'redirects to the created entry' do
  #      post :create, {:entry => valid_attributes}, valid_session
  #      response.should redirect_to(Entry.last)
  #    end
  #  end
  #
  #  describe 'with invalid params' do
  #    it 'assigns a newly created but unsaved entry as @entry' do
  #      # Trigger the behavior that occurs when invalid params are submitted
  #      Entry.any_instance.stub(:save).and_return(false)
  #      post :create, {:entry => { :message => 'invalid value'}}, valid_session
  #      assigns(:entry).should be_a_new(Entry)
  #    end
  #
  #    it 're-renders the \'new\' template' do
  #      # Trigger the behavior that occurs when invalid params are submitted
  #      Entry.any_instance.stub(:save).and_return(false)
  #      post :create, {:entry => { :message => 'invalid value'}}, valid_session
  #      response.should render_template('new')
  #    end
  #  end
  #end
  #
  #describe 'DELETE destroy' do
  #  it 'destroys the requested entry' do
  #    entry = Entry.create! valid_attributes
  #    expect {
  #      delete :destroy, {:id => entry.to_param}, valid_session
  #    }.to change(Entry, :count).by(-1)
  #  end
  #
  #  it 'redirects to the entries list' do
  #    entry = Entry.create! valid_attributes
  #    delete :destroy, {:id => entry.to_param}, valid_session
  #    response.should redirect_to(entries_url)
  #  end
  #end
end
