# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Neighborhood, '新規作成するとき' do
  fixtures :families, :neighborhoods

  before(:each) do
    @neighborhood = Neighborhood.new
    @neighborhood.family_id = 1
    @neighborhood.neighbor_id = 2
  end

  it '拒絶するのは、あり' do
    @neighborhood.rejected = true
    @neighborhood.accepted = false
    @neighborhood.should be_valid
  end

  it '受諾するのは、あり' do
    @neighborhood.rejected = false
    @neighborhood.accepted = true
    @neighborhood.should be_valid
  end

  it '両方するのは、なし' do
    @neighborhood.rejected = true
    @neighborhood.accepted = true
    @neighborhood.should_not be_valid
  end

  it '両方なしは、あり' do
    @neighborhood.rejected = false
    @neighborhood.accepted = false
    @neighborhood.should be_valid
  end

  it '拒絶するかどうか決まってないとだめ' do
    @neighborhood.accepted = false
    @neighborhood.rejected = nil
    @neighborhood.should_not be_valid
  end

  it '受諾するかどうか決まってないとだめ' do
    @neighborhood.accepted = nil
    @neighborhood.rejected = true
    @neighborhood.should_not be_valid
  end

  it '既にある関係と同じ組み合わせはダメ' do
    @neighborhood.family_id = 3
    @neighborhood.rejected = false
    @neighborhood.accepted = false
    @neighborhood.should_not be_valid
  end
end

describe Neighborhood, '既にある関係を操作するとき' do
  fixtures :families, :neighborhoods

  before(:each) do
    @neighborhood = Neighborhood.neighborhood_of(3, 1)
  end

  it '互いの家族のIDで特定できる' do
    @neighborhood.should_not be_nil
    @neighborhood.kind_of?(Neighborhood).should be_true
  end

  it 'acceptするとacceptedになる' do
    @neighborhood.accept.should be_true
    @neighborhood.accepted?.should be_true
    @neighborhood.rejected?.should be_false
    @neighborhood.suspended?.should be_false
  end

  it 'rejectするとrejectedになる' do
    @neighborhood.reject.should be_true
    @neighborhood.accepted?.should be_false
    @neighborhood.rejected?.should be_true
    @neighborhood.suspended?.should be_false
  end

  it 'suspendするとacceptedもrejectedもfalseになる' do
    @neighborhood.suspend.should be_true
    @neighborhood.accepted?.should be_false
    @neighborhood.rejected?.should be_false
    @neighborhood.suspended?.should be_true
  end
end

