class Train

  attr_reader :speed, :wagon_quantity, :type

  def initialize(number, wagon_quantity)
    @number = number
    @wagon_quantity = wagon_quantity
    @speed = 0
  end

  def speed_up
    @speed += 5
  end

  def stop
    @speed = 0
  end

  def change_wagons_quantity(change)
    if @speed > 0
      puts 'You have to stop the train'
      return
    end
    if change == 'up'
      @wagon_quantity += 1
    else
      if @wagon_quantity == 0
        puts 'You already don`t have wagons'
      else
        @wagon_quantity -= 1
      end
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

  def train_type_valid?(type)
    if [:passenger, :cargo].include?(type)
      true
    else
      raise StandardError, 'Invalid train type'
    end
  end
end