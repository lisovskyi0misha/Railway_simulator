class Station

  @@stations = []
  attr_reader :name, :train_list, :train_type_list

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @train_list = []
    @train_type_list = {passenger: 0, cargo: 0}
    add_to_all
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

  private

  def add_to_all
      @@stations << self
  end
end