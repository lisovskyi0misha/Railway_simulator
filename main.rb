require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'station'
require_relative 'route'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'
require_relative 'variants'
require 'pry-byebug'

$first_message = "Choose action: create (element) / choose (element) / stop\n\n"

puts $first_message
action = gets.chomp
elements = {}

include Variants
until action == 'stop'
  case action
  when 'create'
    puts "Choose element to create: #{get_names_from_variants}\n\n"
    element = gets.chomp.to_sym
    puts 'Name your element'
    name = gets.chomp
    if has_requiements?(element)
      begin
        puts "Write attributes with coma for #{element} (#{get_requirements_for(element)})\n\n"
        args = gets.chomp.split(', ')
        elements[name] = VARIANTS[element].keys.first.new(*args)
      rescue StandardError => e
        puts "#{e.message}\n\n"
        retry
      end
    else
      elements[name] = VARIANTS[element].new
    end
    puts "element #{name} was succesfully created\n\n"
  when 'choose'
    if elements.length > 0 
      begin
        puts "Choose one element: #{elements.keys.join(' / ')} or 'next' to skip\n\n"
        element = gets.chomp
        if elements.key?(element)
          puts elements[element].methods
        elsif element == 'next'
        else
          raise StandardError, 'Unknown element'
        end
      rescue StandardError => e
        puts "#{e.message}\n\n"
        retry
      end
    else
      puts 'You don`t have any elements'
    end
  else
    puts 'Unknown action'
  end
  puts $first_message
  action = gets.chomp
end