class Route
  
  attr_reader :station_list
  
  def initialize(station1, station2)
    @first_station = station1
    @last_station = station2
    @station_list = [@first_station]
  end

  def add_station(station)
    @station_list.insert(-2, station)
  end

  def remove_station(station)
    @station_list.delete(station)
  end
end