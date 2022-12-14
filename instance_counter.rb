# frozen_string_literal: false

module InstanceCounter
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    include InstanceCounter

    def instances
      check_or_create_instance_counter(self)
      class_variable_get(:@@instance_counter)
    end
  end

  private

  def register_instance
    check_or_create_instance_counter(self.class)
    increased_instance_counter = self.class.class_variable_get(:@@instance_counter) + 1
    self.class.class_variable_set(:@@instance_counter, increased_instance_counter)
  end

  def check_or_create_instance_counter(cls)
    cls.class_variable_set(:@@instance_counter, 0) unless cls.class_variable_defined?(:@@instance_counter)
  end
end
