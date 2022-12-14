# frozen_string_literal: false

require_relative 'train'
require_relative 'instance_counter'

class PassengerTrain < Train
  include InstanceCounter

  def initialize(number)
    super
    @type = :passenger
    register_instance
  end
end
