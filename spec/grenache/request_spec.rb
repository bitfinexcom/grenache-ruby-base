require 'spec_helper'

describe Grenache::Request do
 let(:payload) { Oj.dump({a: 1, b:2}) }
 let(:request) { Grenache::Request.new('type',payload) }

 it {expect(request.qhash).to eq('type"{\":a\":1,\":b\":2}"') }
end
