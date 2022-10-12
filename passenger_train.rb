require_relative 'train'

class PassengerTrain < Train
  def initialize(number, wagon_quantity)
    super
    @type = :passenger
  end
end