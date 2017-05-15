module Grenache
  # Implement Grape connection helpers
  class Link

    # Initialize passing configuration
    def initialize(config)
      @config = config
    end

    # Connect to grape
    def connect
      unless connected?
        ws_connect
      end
    end

    # Return true if it's connected to Grape
    def connected?
      @connected
    end

    # Disconnect from grape
    def disconnect
      @ws.close
      @ws = nil
    end

    # Send a message to grape
    def send(type, payload, opts = {}, &block)
      if http?
        res = http_send type, Oj.dump({"rid" => uuid, "data" => payload})
        block.call(res) if block
        res
      else
        m = GrapeMessage.new(type,payload,opts, &block)
        messages[m.rid] = m
        ws_send m.to_json
      end
    end

    private

    def messages
      @messages ||= {}
    end

    def grape_url
      @grape_url ||= @config.grape_address
    end

    def http?
      grape_url.start_with? "http"
    end

    def ws_send(payload)
      ws_connect unless connected?
    ensure
      @ws.send(payload)
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

    def ws_connect
      @ws = Faye::WebSocket::Client.new(grape_url)
      @ws.on(:open, method(:on_open))
      @ws.on(:message, method(:on_message))
      @ws.on(:close, method(:on_close))
    end

    def on_open(ev)
      @connected = true
    end

    def on_message(ev)
      msg = Oj.load(ev.data)
      if req = messages[msg[0]]
        messages.delete(msg[0])
        req.yield(msg[1]) if req.block_given?
      end
    end

    def on_close(ev)
      @connected = false
    end

    def uuid
      SecureRandom.uuid
    end
  end
end
