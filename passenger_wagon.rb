# frozen_string_literal: false

require_relative 'accessors'
require_relative 'instance_counter'

class PassengerWagon
  include InstanceCounter
  include Accessors

  attr_accessors_with_history :general_seats, :free_seats, :taken_seats
  attr_reader :type, :free_seats, :taken_seats

  def initialize(seat_number)
    @all_seats = seat_number
    @free_seats = @all_seats
    @taken_seats = 0
    @type = :passenger
    register_instance
  end

  def take_seat
    if @taken_seats == @all_seats
      puts 'All seats are taken'
    else
      @taken_seats += 1
      @free_seats -= 1
    end
  end

  def count_free_seats
    @free_seats
  end

  def count_taken_seats
    @taken_seats
  end
end
