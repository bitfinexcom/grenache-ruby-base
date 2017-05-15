module Grenache

  # Store a single request information
  class GrapeMessage
    attr_accessor :payload, :type, :opts, :_ts

    def initialize(type, payload, opts={}, &block)
      @payload = payload
      @type = type
      @opts = opts
      @rid = opts[:rid]  if opts[:rid]
      @_ts = Time.now
      @block = block
    end

    def self.parse(json)
      rid,type,payload = Oj.load(json)
      if payload.nil?
        payload = type
        type = 'res'
      end
      new(type,payload, {rid:rid})
    end

    def self.req(type,payload)
      new(type,payload)
    end

    def self.response_to(req,payload)
      new('res',payload,{rid: req.rid})
    end

    def request?
      @type != 'res'
    end

    def response?
      @type == 'res'
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
      if response?
        Oj.dump([rid,payload])
      else
        Oj.dump([rid,type,payload])
      end
    end
  end
end
