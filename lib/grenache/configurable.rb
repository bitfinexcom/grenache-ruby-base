module Grenache

  # Encapsulate Configuration parameters
  class Configuration
    # grape configuration
    attr_accessor :grape_address, :timeout

    # service configuration parameters
    attr_accessor :service_timeout, :auto_announce_interval, :auto_announce, :service_host
    # thin server
    attr_accessor :thin_threaded, :thin_threadpool_size

    # service SSL specific configuration
    # Cert is supposed to be PKCS12
    attr_accessor :key, :cert_pem, :ca, :reject_unauthorized, :verify_mode

    # Initialize default values
    def initialize(params = {})
      set_val :grape_address, params, "ws://127.0.0.1:30001"
      set_val :timeout, params, 5

      set_val :auto_announce_interval, params, 5
      set_bool :auto_announce, params, true
      set_val :service_timeout, params, 5
      set_val :service_host, params, "0.0.0.0"

      set_bool :thin_threaded, params, false
      set_val :thin_threadpool_size, params, 0

      set_val :key, params, nil
      set_val :cert_pem, params, nil
      set_val :ca, params, nil
      set_val :reject_unauthorized, params, nil
      set_val :verify_mode, params, Grenache::SSL_VERIFY_PEER
    end

    private
    def set_bool(name, params, default)
      method = "#{name}=".to_sym
      if params[name].nil?
        send(method, default)
      else
        send(method, params[name])
      end
    end

    def set_val(name, params, default)
      method = "#{name}=".to_sym
      if params[name]
        send(method, params[name])
      else
        send(method, default)
      end
    end
  end

  # Configuration helpers
  module Configurable
    def self.included(base)
      base.extend(ClassMethods)
    end

    def config
      self.class.config
    end

    module ClassMethods
      def configure
        yield config
      end

      def config
        @configuration ||= Configuration.new
      end
    end
  end
end
