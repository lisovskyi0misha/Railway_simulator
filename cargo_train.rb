require_relative 'train'

class CargoTrain < Train

  def initialize(number, wagon_quantity)
    super
    @type = :cargo
  end
end