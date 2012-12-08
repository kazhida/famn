# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Family do
  # Familyが持つフィールドは、
  #   name
  # だけ(いまのところは)。

  before(:all) do
    Family.clear
  end

  before(:each) do
    # まっさらな家族を作る
    @family = Family.new
  end

  it 'nameがなければ保存できない。' do
    @family.save.should be_false
  end
end
