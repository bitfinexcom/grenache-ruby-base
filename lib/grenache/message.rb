
module Grenache

  # Store a single request information
  class Message
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

    def yield(params={})
      @block.call(params)
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

    def to_json
      Oj.dump([rid,type,payload])
    end
  end
end
