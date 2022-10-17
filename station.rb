require_relative 'instance_counter'

class Station
  include InstanceCounter

  @@stations = []
  attr_reader :name, :train_list, :train_type_list

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @train_list = []
    @train_type_list = { passenger: 0, cargo: 0 }
    add_to_all
    register_instance
  end

  def take_train(train)
    return 'This train is already on station' if @train_list.include?(train)

    @train_list << train
    @train_type_list[train.type] += 1
  end

  def send_train(train)
    if @train_list.include?(train)
      @train_list.delete(train)
      @train_type_list[train.type] -= 1
    else
      puts 'This train is not on the station'
    end
  end

  def each_train(&block)
    @train_list.each { |train| block.call(train) }
  end

  def show_trains_statistics
    puts 'Trains:'
    each_train do |train|
      p [train.number, train.type, train.wagons.length]
      puts 'Wagons:'
      train.method(:show_wagons_statistics).call
    end
  end

  private

  def add_to_all
    @@stations << self
  end
end
