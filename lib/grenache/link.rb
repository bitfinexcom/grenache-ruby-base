module Grenache

  class Link

    def connect
      unless connected?
        ws_connect
      end
    end
    alias :start :connect

    def connected?
      @connected #delegate to ws?
    end

    def disconnect
      @ws.close
      @ws = nil
      @connected = false
    end
    alias :stop :disconnect

    def request(type, payload, opts = {}, &block)
      req = Request.new(type,payload,opts, block)
      requests[req.rid] = req
    end

    private

    def requests
      @requests ||= {}
    end

    def ws
      @ws ||= ws_connect
    end

    def grape_url
      @grape_url ||= Base.config.grape_address
    end

    def ws_connect
      client = Faye::Websocket::Client.new(grape_url)
      client.on(:open, method(:on_open))
      client.on(:message, method(:on_message))
      client.on(:close, method(:on_close))
      @connected = true
      client
    end

    def on_open(ev)
      puts "WS: connected to #{@grape_url}"
    end

    def on_message(ev)
      msg = oj.parse(ev)
      if req = requests[msg.rid]
        req.yield if req.block_given?
      end
    end

    def on_close(ev)
      puts "WS: disconnect"
    end
  end
end
