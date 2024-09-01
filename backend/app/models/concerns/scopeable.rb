module Scopeable
  extend ActiveSupport::Concern

  class Scope
    attr_accessor :name, :body, :block, :options

    def initialize(name, body, options = {}, &block)
      # guard against name, body, and block options
      reserved = %i[name body block]
      if reserved.any? { |r| options.key?(r) }
        raise ArgumentError, "Scope options cannot include reserved words: #{reserved.join(', ')}"
      end

      @name = name
      @body = body
      @options = options
      @block = block
    end

    # if scope has option :metricable set to true
    # I should be able to call .metricable? on the scope
    # but this should work generally for any option
    def method_missing(method_name, *args, &block)
      if @options.key?(method_name)
        @options[method_name]
      else
        super
      end
    end
  end

  included do

    def self.register_scope(name, body, **kwargs, &block)
      @__scopes__ ||= {}
      @__scopes__[name] = Scope.new(
        name,
        body,
        kwargs,
        &block
      )
      # Rails.logger.info "Scope registered for #{self.name}: #{name}"
      nil
    end

    # wraps ActiveRecord::Scoping::Named::ClassMethods#scope
    # adds the scope name to a @__scopes__ array
    def self.scope(name, body, **kwargs, &block)
      register_scope(name, body, **kwargs, &block)
      super(name, body, &block)
    end

    # e.g. time_period_scope :blahblah
    dynamic_function(/^(?<wildcard>.+)_scope$/) do |capture_groups, method_name, *args, &block|
      wildcard = capture_groups[:wildcard]
      scope_name = args.first
      body = nil
      kwargs = { __wildcard: wildcard }

      args[1..-1].each do |arg|
        if arg.is_a? Proc
          body = arg
        elsif arg.is_a? Hash
          kwargs.merge!(arg)
        else
          raise ArgumentError, "Unexpected argument type: #{arg.class}, value: #{arg}"
        end
      end

      scope(scope_name, body, **kwargs, &block)
    end

    # returns the @__scopes__ hash
    def self.scopes
      arr = @__scopes__ || {}
      if superclass.respond_to?(:scopes)
        # merge but give precedence to arr over superclass.scopes
        superclass.scopes.merge(arr)
      else
        arr
      end
    end

    # e.g. time_period_scopes
    dynamic_function(/^(?<wildcard>.+)_scopes$/) do |capture_groups, method_name, *args, &block|
      wildcard = capture_groups[:wildcard]
      scopes.select { |k, v| v.options[:__wildcard] == wildcard }
    end

  end
end