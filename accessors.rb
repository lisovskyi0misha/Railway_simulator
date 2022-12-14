# frozen_string_literal: false

require 'pry-byebug'

module Accessors
  def self.included(klass)
    klass.extend(ClassMethods)
  end
  
  module ClassMethods
    def attr_accessors_with_history(*args)
      args.each do |var|
        define_method(var.to_sym) { instance_variable_get("@#{var}".to_sym) }
        define_method("#{var}=") do |arg|
          check_or_create_history(var)
          new_history = instance_variable_get("@#{var}_history".to_sym) << instance_variable_get("@#{var}".to_sym)
          instance_variable_set("@#{var}_history".to_sym, new_history)
          instance_variable_set("@#{var}".to_sym, arg)
        end
      end
    end

    def strong_attr_accessor(**kwargs)
      kwargs.each do |var, type|
        define_method(var.to_sym) { instance_variable_get("@#{var}".to_sym) }
        define_method("#{var}=".to_sym) do |value|
          raise StandardError, "Invalid type, must be #{type}" unless value.instance_of?(type)

          instance_variable_set("@#{var}".to_sym, value)
        end
      end
    end
  end

  private

  def check_or_create_history(var)
    unless instance_variable_defined?("@#{var}_history".to_sym)
      instance_variable_set("@#{var}_history".to_sym, []) 
      self.class.define_method("#{var}_history".to_sym) { instance_variable_get("@#{var}_history".to_sym) }
    end
  end
end
