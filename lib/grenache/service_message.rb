module Grenache
  # Message used by services
  class ServiceMessage
    attr_accessor :payload, :err, :rid

    def initialize(payload, err=nil, rid=nil)
      @payload = payload
      @err = err
      @rid = rid || SecureRandom.uuid
    end

    def to_json
      Oj.dump([@rid,@err,@payload])
    end

    def self.parse(json)
      rid, err, payload = Oj.load(json)
      new(payload, err, rid)
    end
  end
end
