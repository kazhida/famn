require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"

  before(:each) do
    # まっさらなユーザを作る
    @user = User.new
  end

  it 'login_nameがなければ保存できない。' do
    @user.save.should be_false
  end

end
