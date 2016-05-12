module Grenache
  class Base
    include Grenache::Configurable

    def lookup(key, opts={})
      link.request('lookup', key, opts)
    end

    def announce(key, port, opts={}, &block)
      if config.auto_announce
        EM.add_periodic_timer(60) do
          send_announce([key,port], opts, block)
        end
      else
        send_announce([key, port], opts, block)
      end
    end

    private

    def send_announce(key, opts={}, &block)
      link.request('announce', key, opts, block)
    end

    def link
      @link ||= Link.new
      @link.connect if @link.disconnected?
      @link
    end
  end
end
