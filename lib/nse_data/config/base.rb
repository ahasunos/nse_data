# frozen_string_literal: true

module NseData
  module Config
    # Base serves as the base class for configuration settings.
    #
    # It allows for storing and accessing various configuration settings
    # through a hash-like interface.
    #
    # @attr_reader [Hash] settings The hash storing configuration settings.
    class Base
      attr_reader :settings

      # Initializes the Base with optional initial settings.
      #
      # @param initial_settings [Hash] Optional hash of initial settings.
      def initialize(initial_settings = {})
        @settings = initial_settings
      end

      # Retrieves a configuration setting by key.
      #
      # @param key [Symbol, String] The key for the setting.
      # @return [Object] The value associated with the key.
      def [](key)
        @settings[key]
      end

      # Sets a configuration setting by key.
      #
      # @param key [Symbol, String] The key for the setting.
      # @param value [Object] The value to set for the key.
      def []=(key, value)
        @settings[key] = value
      end
    end
  end
end
