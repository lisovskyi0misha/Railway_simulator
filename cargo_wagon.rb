class CargoWagon
  include InstanceCounter

  attr_reader :type, :free_capacity, :taken_capacity

  def initialize(general_capacity)
    @general_capacity = general_capacity
    @free_capacity = @general_capacity
    @taken_capacity = 0
    @type = :cargo
    register_instance
  end

  def take_capacity(capacity)
    if @taken_capacity + capacity > @general_capacity
      puts 'Not enough capacity'
    else
      @take_capacity += capacity
      @free_capacity -= capacity
    end
  end

  def get_free_capacity
    @free_capacity
  end

  def get_taken_capacity
    @taken_capacity
  end
end
