# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Family, '新規作成するとき' do
  # Familyが持つフィールドは、
  #   name
  # だけ(いまのところは)。

  before(:all) do
    Family.destroy_all
  end

  before(:each) do
    # まっさらな家族を作る
    @family = Family.new
  end

  it 'nameがなければいけない' do
    @family.should_not be_valid
  end
end
