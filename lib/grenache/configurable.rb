module Grenache
  class Configuration

    def initialize(params = {})
      @values ||= {}
      self.class.configuration_blocks.each do |b|
        b.call self
      end

      params.keys.each do |k|
        @values[k.to_s] = params[k]
      end
    end

    def self.default_conf &block
      @configuration_blocks ||= []
      @configuration_blocks << block
    end

    def self.configuration_blocks
      @configuration_blocks || []
    end

    def method_missing(name, *args, &block)
      if name[-1] == "="
        @values[name[0,name.size-1]] = args.first
      else
        @values[name.to_s]
      end
    end
  end

  # Configuration helpers
  module Configurable
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Instance configuration, can be altered indipendently
    def config
      @configuration ||= self.class.config
    end

    module ClassMethods
      def configure
        yield config
      end

      # Class configuration
      def config
        @configuration ||= Configuration.new
      end
    end
  end
end
