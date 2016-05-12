module Grenache
  class Request
    attr_accessor :payload, :type, :opts, :_ts

    def initialize(type, payload, opts={}, &block)
      @payload = payload
      @type = type
      @opts = opts
      @_ts = Time.now
      @block = block
    end

    def block_given?
      !!@block
    end

    def yield
      @block.call
    end

    def rid
      @rid ||= SecureRandom.uuid
    end

    def qhash
      "#{type}#{dump_payload}"
    end

    def dump_payload
      @dump_payload ||= Oj.dump(payload)
    end
  end
end
