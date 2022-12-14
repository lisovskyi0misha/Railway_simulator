class CargoWagon
  include InstanceCounter

  attr_reader :type
  
  def initialize
    @type = :cargo
    register_instance
  end
end