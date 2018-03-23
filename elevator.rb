require 'pp'
require_relative 'move'
require_relative 'person'
require_relative 'randomizer'

class Elevator

  attr_reader :floors
  attr_accessor :moving
  def initialize(floors)
    @floors = floors
    Move.direction = :not_set
    Person.clear
    Move.set_floors_numbers(floors)
    @moving = false
  end

  def perform
    Move.begin_message
    make_random_call until Person.all != []
    deliver_persons
  end

  def call(asked_direction, floor)
    Move.change_direction(asked_direction) if floor != Move.current_floor
    Person.new(start: floor, destination:terminus).ask_elevator if can_take_elevator_now?(asked_direction, floor)
  end

  private

  def deliver_persons
    @moving = true
    Move.up until Move.current_floor == Person.first.start
    until Person.all.empty? || Move.current_floor == Person.last_stop(Move.direction)
      make_random_call
      choose_destination?
      Move.in_set_direction
      Person.arrived?(Move.current_floor)
    end
  end

  def can_take_elevator_now?(asked_direction, floor)
    asked_direction == Move.direction && not_too_late_to_take_elevator?(floor) && not_terminus?(floor)
  end

  def not_too_late_to_take_elevator?(floor)
    return false if Move.direction == :down && floor > Move.current_floor && moving == true
    return false if Move.direction == :up && floor < Move.current_floor && moving == true
    true
  end

  def not_terminus?(floor)
    floor != terminus
  end

  def terminus
    return floors if Move.direction == :up
    return 0 if Move.direction == :down || Move.direction == :not_set
  end


  def choose_destination?
    choose_random_destination if Person.starts.include?(Move.current_floor)
  end

  def choose_random_destination
    params = { current_floor: Move.current_floor, limit: floors, direction: Move.direction }
    random_floor = Randomizer.new(params).destination
    until random_floor != Move.current_floor
      random_floor = Randomizer.new(params).destination
    end
    Person.set_destination_of_persons_on_this_floor(random_floor,Move.current_floor)
  end

  def make_random_call
    random = Randomizer.new(limit: 1).call
    random_start = Randomizer.new(limit: floors).call
    call(Move::DIRECTIONS[random], random_start)
  end

end

# Elevator.new(10).perform
