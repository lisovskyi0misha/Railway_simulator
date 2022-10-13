class PassengerWagon
  include InstanceCounter

  attr_reader :type
  
  def initialize
    @type = :passenger
    register_instance
  end
end