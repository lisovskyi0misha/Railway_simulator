require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'station'
require_relative 'route'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

t1 = PassengerTrain.new('1')

s1 = Station.new('one')
s2 = Station.new('two')
s3 = Station.new('three')
s4 = Station.new('four')

r1 = Route.new(s1,s2)

w1 = PassengerWagon.new

r1.add_station(s3)
r1.add_station(s4)

t1.take_route(r1)

t1.change_wagons_quantity('add', w1)
