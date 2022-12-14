# frozen_string_literal: false

require_relative 'instance_counter'
require_relative 'names'
require_relative 'validation'

class Train
  include InstanceCounter
  include Names
  include Validation
  @@trains = {}

  attr_reader :speed, :wagons, :type, :number

  validate number: {format: /\A[0-9a-zA-Z]{3}-{,1}[0-9a-zA-Z]{2}\z/}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number)
    @number = number
    validate!
    @type = nil
    @wagons = []
    @speed = 0
    @@trains[number] = self
  end

  def speed_up
    @speed += 5
  end

  def stop
    @speed = 0
  end

  def change_wagons_quantity(change, wagon)
    check_conditions(change, wagon)
    @wagons << wagon if change == 'add'
    @wagons.delete(wagon) if change == 'remove'
  rescue StandardError => e
    puts e.message
  end

  def take_route(route)
    @route = route
    @route_stations = @route.station_list
    @current_station = @route_stations.first
    @current_station.take_train(self)
    @next_station = @route_stations[@route_stations.index(@current_station) + 1]
  end

  def move_to_next_station
    if @current_station == @route_stations.last
      move_last
    else
      move_next
    end
  end

  def show_stations
    puts "Previous station is #{@previous_station.name}" unless @previous_station.nil?
    puts "Current station is #{@current_station.name}"
    puts "Next station is #{@next_station.name}" unless @next_station.nil?
  end

  def each_wagon(&block)
    @wagons.each_with_index { |wagon, ind| block.call(wagon, ind + 1) }
  end

  def show_wagons_statistics
    each_wagon do |wagon, ind|
      if wagon.type == :cargo
        p [ind, wagon.type, "Taken capacity: #{wagon.taken_capacity}", "Free capacity: #{wagon.free_capacity}"]
      else
        p [ind, wagon.type, "Taken capacity: #{wagon.taken_seats}", "Free capacity: #{wagon.free_seats}"]
      end
    end
  end

  private

  def move_last
    @next_station = nil
    puts 'Train has already arrived to last staion'
    @route = nil
  end

  def move_next
    @previous_station = @current_station
    @previous_station.send_train(self)
    @current_station = @next_station
    @current_station.take_train(self)
    @next_station = @route_stations[@route_stations.index(@current_station) + 1]
  end

  def check_conditions(change, wagon)
    raise StandardError, 'You have to stop the train' if @speed.positive?
    raise StandardError, 'Wrong type of wagon' unless wagon.type == @type
    raise StandardError, 'You don`t have wagons' if @wagons.count.zero? && change == 'remove'
    raise StandardError, 'You don`t have this wagon' if !@wagons.include?(wagon) && change == 'remove'
    raise StandardError, 'You already have this wagon' if @wagons.include?(wagon) && change == 'add'
  end
end
