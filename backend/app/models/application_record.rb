class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  SIGNAL_DYNAMIC_FUNCTION_NOT_FOUND = "<DYNAMIC_FUNCTION_NOT_FOUND>"

  def self.method_missing(method_name, *args, &block)
    if self.respond_to?(:_call_dynamic_function)
      begin 
        r = _call_dynamic_function(method_name, *args, &block)
        if r == SIGNAL_DYNAMIC_FUNCTION_NOT_FOUND
          super
        else
          r
        end
      rescue NoMethodError
        super
      end
    else
      super
    end
  end

  def self.dynamic_function(regex, &block)
    @__dynamic_functions__ ||= {}
    @__dynamic_functions__[regex] = block
    Rails.logger.info "Dynamic function registered for #{self.name}: #{regex}"
  end

  # all includes must come after self.method_missing and self.dynamic_function
  include Scopeable

  def self._call_dynamic_function(method_name, *args, &block)
    block_found = nil
    capture_groups = nil

    @__dynamic_functions__ ||= {}
    @__dynamic_functions__.each do |regex, block|
      capture_groups = regex.match(method_name)
      if capture_groups
        block_found = block
        break
      end
    end

    # if the parent class respond_to call_dynamic_function, call it
    if block_found
      block_found.call(capture_groups, method_name, *args)
    elsif superclass.respond_to?(:_call_dynamic_function)
      superclass._call_dynamic_function(method_name, *args, &block)
    else
      "<DYNAMIC_FUNCTION_NOT_FOUND>"
    end
  end

  def self.model
    self.name.underscore.downcase.pluralize
  end

  def model
    self.class.model
  end

  # returns the blueprinter class for this model
  def self.blueprinter_class
    "#{self.name}Blueprint".constantize
  end

  def blueprinter_class
    self.class.blueprinter_class
  end

  # override the default as_json method to use blueprinter
  def as_json(options = {})
    blueprinter_class.render_as_hash(self, options)
  end

  def as_hash(options = {})
    blueprinter_class.render_as_hash(self, options)
  end
end