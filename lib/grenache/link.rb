module Grenache
  # Implement Grape connection helpers
  class Link

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

    # Send a request to grape
    def send(type, payload, opts = {}, &block)
      req = Request.new(type,payload,opts, &block)
      requests[req.rid] = req
      ws_send req.to_json
    end

    private

    def requests
      @requests ||= {}
    end

    def grape_url
      @grape_url ||= Base.config.grape_address
    end

    def ws_send(payload)
      ws_connect unless connected?
      @ws.send(payload)
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
      if req = requests[msg[0]]
        req.yield(msg) if req.block_given?
      end
    end

    def on_close(ev)
      @connected = false
    end
  end
end
