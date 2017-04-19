require 'spec_helper'

describe Grenache::VERSION do
  it { expect(Grenache::VERSION).not_to be nil }

  describe Grenache::Configuration do
    before do
      @conf = Grenache::Configuration.new timeout: 10
    end

    it { expect(@conf.timeout).to eq(10) }
  end

  describe Grenache::Base do
    before do
      @base = Grenache::Base.new timeout: 10
    end

    it { expect(@base.config.timeout).to eq(10) }
  end
end

