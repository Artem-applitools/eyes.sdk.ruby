# frozen_string_literal: true

require 'applitools/core/rectangle_size'
require 'applitools/core/session_types'
require 'applitools/core/batch_info'
require 'applitools/connectivity/proxy'
require 'applitools/core/match_level'
require 'applitools/core/match_level_setter'
require 'applitools/connectivity/server_connector'
require 'applitools/core/image_match_settings'

module Applitools
  class EyesBaseConfiguration < AbstractConfiguration
    DEFAULT_CONFIG = {
      branch_name: ENV['APPLITOOLS_BRANCH'],
      parent_branch_name: ENV['APPLITOOLS_PARENT_BRANCH'],
      baseline_branch_name: ENV['APPLITOOLS_BASELINE_BRANCH'],
      save_diffs: false,
      server_url: ENV['APPLITOOLS_SERVER_URL'] ||
        ENV['bamboo_APPLITOOLS_SERVER_URL'] || Applitools::Connectivity::ServerConnector::DEFAULT_SERVER_URL,
      api_key: ENV['APPLITOOLS_API_KEY'] || ENV['bamboo_APPLITOOLS_API_KEY'] || '',
      save_new_tests: true,
      default_match_settings: Applitools::ImageMatchSettings.new,
      accessibility_validation: nil,
      properties: []
    }.freeze

    class << self
      def default_config
        DEFAULT_CONFIG
      end
    end

    def initialize
      super
      # self.batch_info = Applitools::BatchInfo.new
    end

    def merge(other_config)
      return if object_id == other_config.object_id
      (config_keys + other_config. config_keys).uniq do |k|
        merge_key(other_config, k)
      end
    end

    def merge_key(other_config, key)
      return unless other_config.send("defined_#{key}?")
      return unless respond_to?("#{key}=")
      send("#{key}=", other_config.send(key))
    end

    def config_keys
      config_hash.keys
    end

    def to_s
      config_keys.map do |k|
        "#{k} = #{send(k)}"
      end.join("\n")
    end

    def valid?
      validation_errors.clear

      validation_errors[:app_name] = ':app_name is required' unless app_name
      validation_errors[:test_name] = ':test_name is required' unless test_name

      validation_errors[:app_name] = ':app_name is required' if app_name && app_name.empty?
      validation_errors[:test_name] = ':test_name is required' if test_name && test_name.empty?
      # validation_errors[:viewport_size] = ':viewport_size is required' if viewport_size.square.zero?
      return true if validation_errors.keys.size.zero?
      false
    end

    def batch
      if batch_info.nil?
        Applitools::EyesLogger.info 'No batch set'
        self.batch_info = BatchInfo.new
      end
      batch_info
    end

    def batch=(value)
      self.batch_info = value
    end

    methods_to_delegate.push :batch
    methods_to_delegate.push :batch=

    string_field :branch_name
    string_field :parent_branch_name
    string_field :baseline_branch_name
    string_field :agent_id
    string_field :environment_name
    boolean_field :save_diffs
    boolean_field :save_new_tests
    enum_field :session_type, Applitools::SessionTypes.enum_values
    object_field :batch_info, Applitools::BatchInfo
    string_field :baseline_env_name
    string_field :app_name
    string_field :test_name
    object_field :viewport_size, Applitools::RectangleSize
    string_field :api_key
    string_field :server_url
    string_field :host_os
    string_field :host_app
    object_field :proxy, Applitools::Connectivity::Proxy
    enum_field :match_level, Applitools::MatchLevel.enum_values
    object_field :exact, Applitools::ImageMatchSettings::Exact
    object_field :default_match_settings, Applitools::ImageMatchSettings
    int_field :scale
    int_field :remainder
    boolean_field :ignore_caret
    boolean_field :ignore_displacements
    object_field :accessibility_validation, Applitools::AccessibilitySettings, true
    object_field :properties, Array

    methods_to_delegate.delete(:batch_info)
    methods_to_delegate.delete(:batch_info=)

    def short_description
      "#{test_name} of #{app_name}"
    end

    def set_proxy(uri, user = nil, password = nil)
      self.proxy = Applitools::Connectivity::Proxy.new(uri, user, password)
    end

    def custom_setter_for_exact(value)
      default_match_settings.exact = value
    end

    def custom_setter_for_match_level(value)
      default_match_settings.match_level = value
    end

    def custom_setter_for_scale(value)
      default_match_settings.scale = value
    end

    def custom_setter_for_remainder(value)
      default_match_settings.remainder = value
    end

    def custom_setter_for_ignore_displacements(value)
      default_match_settings.ignore_displacements = value
    end

    def custom_getter_for_ignore_displacements(_value)
      default_match_settings.ignore_displacements
    end

    def custom_getter_for_exact(_value)
      default_match_settings.exact
    end

    def custom_getter_for_scale(_value)
      default_match_settings.scale
    end

    def custom_getter_for_remainder(_value)
      default_match_settings.remainder
    end

    def custom_getter_for_match_level(_value)
      default_match_settings.match_level
    end

    def custom_getter_for_ignore_caret(_value)
      default_match_settings.ignore_caret
    end

    def custom_setter_for_ignore_caret(value)
      default_match_settings.ignore_caret = value
    end

    def custom_setter_for_accessibility_validation(value)
      # self.default_match_settings = self.parent.class.default_config[:default_match_settings] unless default_match_settings
      default_match_settings.accessibility_validation = value
    end

    def add_property(name, value)
      properties << { name: name, value: value } if name && value
    end

    methods_to_delegate.push(:set_proxy)
    methods_to_delegate.push(:add_property)
  end
end
