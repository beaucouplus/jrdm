require 'pp'
require_relative 'move'
require_relative 'person'
require_relative 'randomizer'

class Elevator

  attr_reader :floors
  def initialize(floors)
    @floors = floors
    Move.direction = :not_set
    Move.ongoing = false
    Person.clear
    Move.set_floors_numbers(floors)
  end

  def perform
    Move.begin_message
    make_random_call until Person.all != []
    deliver_persons
  end

  def call(asked_direction, floor)
    Move.change_direction(asked_direction) if floor != current_floor
    Person.new(start: floor, destination:terminus).ask_elevator if can_take_elevator_now?(asked_direction, floor)
  end

  private

  def deliver_persons
    Move.ongoing = true
    Move.up until take_first_passenger
    until last_passenger_is_arrived
      make_random_call
      choose_destination?
      Move.in_set_direction
      Person.arrived?(current_floor)
    end
  end

  def take_first_passenger
    current_floor == Person.first.start
  end

  def last_passenger_is_arrived
    Person.all.empty? || current_floor == Person.last_stop(Move.direction)
  end

  def can_take_elevator_now?(asked_direction, floor)
    asked_direction == current_direction && not_too_late_to_take_elevator?(floor) && not_terminus?(floor)
  end

  def not_too_late_to_take_elevator?(floor)
    return false if too_late_to_go_down?(floor)
    return false if too_late_to_go_up?(floor)
    true
  end

  def too_late_to_go_down?(floor)
    current_direction == :down && floor > current_floor && Move.ongoing == true
  end

  def too_late_to_go_up?(floor)
    current_direction == :up && floor < current_floor && Move.ongoing == true
  end

  def not_terminus?(floor)
    floor != terminus
  end

  def terminus
    return floors if current_direction == :up
    return 0 if current_direction == :down || current_direction == :not_set
  end

  def choose_destination?
    choose_random_destination if Person.starts.include?(current_floor)
  end

  def choose_random_destination
    params = { current_floor: current_floor, limit: floors, direction: current_direction }
    random_floor = Randomizer.new(params).destination
    until random_floor != current_floor
      random_floor = Randomizer.new(params).destination
    end
    Person.set_destination_of_persons_on_this_floor(random_floor,current_floor)
  end

  def make_random_call
    random = Randomizer.new(limit: 1).call
    random_start = Randomizer.new(limit: floors).call
    call(Move::DIRECTIONS[random], random_start)
  end

  def current_floor
    Move.current_floor
  end

  def current_direction
    Move.direction
  end

end

# Elevator.new(10).perform
