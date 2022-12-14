require 'pry-byebug'

module Validation
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def validate!
    message = ''
    instance_variables.each do |var|
      cleaned_var = var.to_s.delete('@')
      begin
        method("#{cleaned_var}_validate!".to_sym).call if methods.include?("#{cleaned_var}_validate!".to_sym)
      rescue StandardError => e
        message << "#{var} #{e.message}.\n"
      end
    end
    raise StandardError, message unless message.empty?
  end

  module ClassMethods
    def validate(**kwargs)
      kwargs.each do |var, validation|
        if validation == :presence
          define_presence_setter(var)
          define_presence_validator(var)
        elsif validation.key?(:format)
          define_format_setter(var, validation.values.first)
          define_format_validator(var, validation.values.first)
        elsif validation.key?(:type)
          define_type_setter(var, validation.values.first)
          define_type_validator(var, validation.values.first)
        end
        define_method(var.to_sym) { instance_variable_get("@#{var}".to_sym) }
      end
    end

    def define_presence_setter(var)
      define_method("#{var}=".to_sym) do |value|
        raise StandardError, 'Can`t be blank!' if value.nil? || value.instance_of?(String) && value.empty?

        instance_variable_set("@#{var}".to_sym, value)
      end
    end

    def define_format_setter(var, format)
      define_method("#{var}=".to_sym) do |value|
        raise StandardError, 'Invalid format!' unless format.match?(value)

        instance_variable_set("@#{var}".to_sym, value)
      end
    end

    def define_type_setter(var, type)
      define_method("#{var}=".to_sym) do |value|
        raise StandardError, "Invalid type, must be #{type}!" unless value.instance_of?(type)

        instance_variable_set("@#{var}".to_sym, value)
      end
    end

    def define_presence_validator(var)
      define_method("#{var}_validate!".to_sym) do
        value = instance_variable_get("@#{var}".to_sym)
        raise StandardError, 'must not be blank' if value.nil? || value.instance_of?(String) && value.empty?
      end
    end

    def define_format_validator(var, format)
      define_method("#{var}_validate!".to_sym) do
        raise StandardError, 'has invalid format' unless format.match?(instance_variable_get("@#{var}".to_sym))
      end
    end

    def define_type_validator(var, type)
      define_method("#{var}_validate!".to_sym) do
      value = instance_variable_get("@#{var}".to_sym)
      # binding.pry
        raise StandardError, "has invalid type, must be #{type}" unless value.instance_of?(type)
      end
    end
  end
end
