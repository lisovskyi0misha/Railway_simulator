require_relative 'instance_counter'
require_relative 'names'

class Train
  include InstanceCounter
  include Names
  @@trains = {}

  attr_reader :speed, :wagons, :type, :number

  def self.find(number)
    @@trains[number]
  end

  def initialize(number)
    @type = nil
    @number = number
    a = 0
    begin
      validate!
    rescue StandardError => e
      puts e.message
      a += 1
      retry if a < 5
    end
    @wagons = []
    @speed = 0
    @type = type
    @@trains[number] = self
  end

  def speed_up
    @speed += 5
  end

  def stop
    @speed = 0
  end

  def change_wagons_quantity(change, wagon)
    begin
      check_conditions(change, wagon)
      @wagons << wagon if change == 'add'
      @wagons.delete(wagon) if change == 'remove'
    rescue StandardError => e
      puts e.message
    end
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
      @next_station = nil
      puts 'Train has already arrived to last staion'
      @route = nil
    else
      @previous_station = @current_station
      @previous_station.send_train(self)    
      @current_station = @next_station
      @current_station.take_train(self)
      @next_station = @route_stations[@route_stations.index(@current_station) + 1]
    end
  end

  def show_stations
    puts "Previous station is #{@previous_station.name}" unless @previous_station.nil?
    puts "Current station is #{@current_station.name}"
    puts "Next station is #{@next_station.name}" unless@next_station.nil?
  end

  private

  def valid?(number)
    regexp = /\A[0-9a-zA-Z]{3}-{,1}[0-9a-zA-Z]{2}\z/
    regexp.match?(number)
  end

  def validate!
    raise StandardError, 'Invalid number format' unless valid?(@number)
  end

#useless for user
  def check_conditions(change, wagon)
    raise StandardError, 'You have to stop the train' if @speed > 0
    raise StandardError, 'Wrong type of wagon' unless wagon.type == @type
    raise StandardError, 'You don`t have wagons' if @wagons.count == 0 && change == 'remove'
    raise StandardError, 'You don`t have this wagon' if (not @wagons.include?(wagon)) && change == 'remove'
    raise StandardError, 'You already have this wagon' if @wagons.include?(wagon) && change == 'add'
  end
end
