# frozen_string_literal: false

require 'pry-byebug'

module Accessors
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  instance_variables.each do |var|
    deifine_method("#{var}_history".to_sym) { instance_variable_get("@#{var}_history".to_sym) }
  end

  def check_or_create_history(var)
    instance_variable_set("@#{var}_history".to_sym, []) unless instance_variable_defined?("@#{var}_history".to_sym)
  end

  module ClassMethods
    def attr_accessors_with_history(*args)
      args.each do |var|
        define_method(var.to_sym) { instance_variable_get("@#{var}".to_sym) }
        define_method("#{var}=") do |arg|
          instance_variable_set("@#{var}".to_sym, arg)
          check_or_create_history(var)
          new_history = instance_variable_get("@#{var}_history".to_sym) << arg
          instance_variable_set("@#{var}_history".to_sym, new_history)
        end
      end
    end

    def strong_attr_accessor(**kwargs)
      kwargs.each do |var, type|
        define_method(var.to_sym) { instance_variable_get("@#{var}".to_sym) }
        define_method("#{var}=".to_sym) do |data|
          raise StandardError, "Invalid type, must be #{type}" unless data.instance_of?(type)

          instance_variable_set("@#{var}".to_sym, data)
        end
      end
    end
  end
end

class First
  include Accessors

  attr_accessors_with_history :var
  strong_attr_accessor var: Integer
end

    binding.pry

f = First.new
f.var = 5
