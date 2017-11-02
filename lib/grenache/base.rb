module Grenache
  class Base
    include Grenache::Configurable

    # Set default configuration values for BASE
    default_conf do |conf|
      conf.grape_address = "http://127.0.0.1:40001/"
      conf.auto_announce = true
      conf.timeout = 5
      conf.auto_announce_interval = 5
      conf.service_host = "0.0.0.0"
      conf.cache_expire = 5
    end

    # Initialize can accept custom configuration parameters
    def initialize(params = {})
      @configuration = Configuration.new(params)
    end

    # Lookup for a specific service `key`
    # passed block is called with the result values
    # in case of `http` backend it return the result directly
    # @param key [string] identifier of the service
    def lookup(key, opts={}, &block)
      unless addr = cache.has?(key)
        addr = link.send('lookup', key, opts, &block)
        cache.save(key, addr)
      end
      yield addr if block_given?
      addr
    end

    # Announce a specific service `key` available on specific `port`
    # passed block is called when the announce is sent
    # @param key [string] service identifier
    # @param port [int] service port number
    # @block callback
    def announce(key, port, opts={}, &block)
      payload = [key,port]
      link.send 'announce', payload, opts, &block
      if config.auto_announce
        periodically(config.auto_announce_interval) do
          link.send 'announce', payload, opts, &block
        end
      end
    end

    private

    def cache
      @cache ||= Cache.new(config.cache_expire)
    end

    def periodically(seconds)
      EM.add_periodic_timer(seconds) do
        yield
      end
    end

    def link
      @link ||= Link.new config
    end
  end
end
