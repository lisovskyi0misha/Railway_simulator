# frozen_string_literal: false

require_relative 'accessors'
require_relative 'instance_counter'

class CargoWagon
  include InstanceCounter
  include Accessors

  attr_accessors_with_history :general_capacity, :free_capacity, :taken_capacity

  def initialize(general_capacity)
    @general_capacity = general_capacity
    @free_capacity = @general_capacity
    @taken_capacity = 0
    @type = :cargo
    register_instance
  end

  def take_capacity(capacity)
    if @taken_capacity + capacity > @general_capacity
      puts 'Not enough capacity'
    else
      @take_capacity += capacity
      @free_capacity -= capacity
    end
  end
end
