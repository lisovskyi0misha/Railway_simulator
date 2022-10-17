require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'station'
require_relative 'route'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'
require_relative 'helpers'
require 'pry-byebug'

first_message = "\nChoose action: create (element) / choose (element) / stop\n\n"

puts first_message
action = gets.chomp
elements = {
  's1' => Station.new('some name'),
  'pt' => PassengerTrain.new('111-11'),
  'ct' => CargoTrain.new('222-22'),
  'cw1' => CargoWagon.new(1000),
  'cw2' => CargoWagon.new(2000),
  'pw1' => PassengerWagon.new(50),
  'pw2' => PassengerWagon.new(100)
}

[elements['cw1'], elements['cw2']].each { |wagon| elements['ct'].change_wagons_quantity('add', wagon) }
[elements['pw1'], elements['pw2']].each { |wagon| elements['pt'].change_wagons_quantity('add', wagon) }

[elements['pt'], elements['ct']].each { |t| elements['s1'].take_train(t) }

# include Helpers
until action == 'stop'
  case action
  when 'create'
    puts "\nChoose element to create: #{get_names_from_variants}\n\n"
    element = gets.chomp.to_sym
    puts "\nName your element"
    name = gets.chomp
    if has_requiements?(element)
      begin
        puts "\nWrite attributes with coma for #{element} (#{get_requirements_for(element)})\n\n"
        args = gets.chomp.split(', ')
        elements[name] = VARIANTS[element].keys.first.new(*args)
      rescue StandardError => e
        puts "#{e.message}\n\n"
        retry
      end
    else
      elements[name] = VARIANTS[element].new
    end
    puts "\nElement #{name} was succesfully created\n\n"
  when 'choose'
    if elements.length > 0
      begin
        puts "\nChoose one element: #{elements.keys.join(' / ')} or 'next' to skip\n\n"
        element = gets.chomp
        if elements.key?(element)
          object_class = ACTIONS[elements[element].class]
          puts "\nChoose action: #{object_class.keys.join(' / ')}"
          action = gets.chomp
          elements[element].method(object_class[action]).call
        elsif element == 'next'
        else
          raise StandardError, 'Unknown element'
        end
      rescue StandardError => e
        puts "#{e.message}\n\n"
        retry
      end
    else
      puts "\nYou don`t have any elements\n\n"
    end
  else
    puts "\nUnknown action\n\n"
  end
  puts first_message
  action = gets.chomp
end