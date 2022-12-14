module Variants
  VARIANTS = {
    passenger_train: {PassengerTrain => ['number']}, 
    cargo_train: {CargoTrain => ['number']}, 
    cargo_wagon: CargoWagon,
    passenger_wagon: PassengerWagon,
    route: {Route => ['first_station', 'last_station']}, 
    station: {Station => ['name']}
    }

  def get_names_from_variants
    message = VARIANTS.keys.join(' / ') 
  end

  def get_requirements_for(element)
    requirements = VARIANTS[element].values.first.join(', ')
  end

  def has_requiements?(element)
    VARIANTS[element].class == Hash
  end
end