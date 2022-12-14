# frozen_string_literal: false

module Helpers
  VARIANTS = {
    passenger_train: { PassengerTrain => ['number'] },
    cargo_train: { CargoTrain => ['number'] },
    cargo_wagon: { CargoWagon => ['general_capacity'] },
    passenger_wagon: { PassengerWagon => ['general_seats'] },
    route: { Route => %w[first_station, last_station] },
    station: { Station => ['name'] }
  }

  ACTIONS = {
    PassengerTrain => { 'show wagons' => :show_wagons_statistics },
    CargoTrain => { 'show wagons' => :show_wagons_statistics },
    CargoWagon => { 'take capacity' => :take_capacity },
    PassengerWagon => { 'take seat' => :take_seat },
    Route => %w[first_station, last_station],
    Station => { 'show trains' => :show_trains_statistics }
  }

  def get_names_from_variants
    VARIANTS.keys.join(' / ')
  end

  def get_requirements_for(element)
    VARIANTS[element].values.first.join(', ')
  end

  def requiements?(element)
    VARIANTS[element].instance_of?(Hash)
  end
end
