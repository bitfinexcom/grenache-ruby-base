require 'spec_helper'

describe Grenache::Message do
 let(:payload) { Oj.dump({a: 1, b:2}) }
 let(:request) { Grenache::Message.new('type',payload) }

 it {expect(request.qhash).to eq('type"{\":a\":1,\":b\":2}"') }
end
