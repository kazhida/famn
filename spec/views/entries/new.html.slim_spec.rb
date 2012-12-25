require 'spec_helper'

describe "entries/new" do
  before(:each) do
    assign(:entry, stub_model(Entry,
      :message => "MyText",
      :user_id => 1,
      :family_id => 1
    ).as_new_record)
  end

  it "renders new entry form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => entries_path, :method => "post" do
      assert_select "textarea#entry_message", :name => "entry[message]"
      assert_select "input#entry_user_id", :name => "entry[user_id]"
      assert_select "input#entry_family_id", :name => "entry[family_id]"
    end
  end
end
