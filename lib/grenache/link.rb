module Grenache
  # Implement Grape connection helpers
  class Link

    # Initialize passing configuration
    def initialize(config)
      @config = config
    end

    # Send a message to grape
    def send(type, payload, opts = {}, &block)
      res = http_send type, Oj.dump({"rid" => uuid, "data" => payload})
      block.call(res) if block
      res
    end

    private

    def grape_url
      @grape_url ||= @config.grape_address
    end

    def http_send(type, payload)
      url = grape_url + type
      options = {
        body: payload,
        timeout: Base.config.timeout
      }
      res = HTTParty.post(url, options).body
      Oj.load(res)
    rescue => err
      if type != 'announce'
        raise err
      end
    end

    def uuid
      SecureRandom.uuid
    end
  end
end
