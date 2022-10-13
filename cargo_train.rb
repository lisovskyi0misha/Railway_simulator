require_relative 'train'

class CargoTrain < Train
  include InstanceCounter

  def initialize(number)
    super
    @type = :cargo
    register_instance
  end
end