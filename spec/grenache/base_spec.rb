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
      Grenache::Base.configure do |conf|
        conf.timeout = 10
      end
    end

    it { expect(Grenache::Base.config.timeout).to eq(10) }

    it { expect(Grenache::Base.new( timeout: 11).config.timeout).to eq(11) }
  end


end

