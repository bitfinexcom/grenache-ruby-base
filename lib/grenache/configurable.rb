module Grenache

  # Encapsulate Configuration parameters
  class Configuration
    attr_accessor :grape_address, :auto_announce, :timeout

    # Initialize default values
    def initialize
      self.grape_address = "ws://127.0.0.1:30001"
      self.auto_announce = true
      self.timeout = 5
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
