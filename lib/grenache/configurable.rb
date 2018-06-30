module Grenache
  class BaseConfiguration
    def values
      @values ||= {}
    end

    def method_missing(name, *args, &block)
      if name[-1] == "="
        values[name[0,name.size-1]] = args.first
      else
        values[name.to_s]
      end
    end
  end

  class Configuration < BaseConfiguration

    def initialize(params = {})
      @values = self.class.default.values

      params.each do |k, v|
        @values[k.to_s] = v
      end

      # sanitize urls
      if not @values["grape_address"].end_with?("/")
        @values["grape_address"] = @values["grape_address"] + "/"
      end
    end

    def self.set_default &block
      yield default
    end

    def self.default
      @defaults ||= BaseConfiguration.new
    end

  end

  # Configuration helpers
  module Configurable
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Instance configuration, can be altered indipendently
    def config
      @configuration ||= Configuration.new
    end

    module ClassMethods
      def configure
        yield config
      end

      # Class configuration
      def config
        @configuration ||= Configuration.new
      end

      def default_conf &block
        Grenache::Configuration.set_default &block
      end
    end
  end
end
