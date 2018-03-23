require 'minitest/autorun'
require_relative 'elevator'

class ElevatorTest < Minitest::Test

  def setup
    @elevator = Elevator.new(10)
  end

  def test_floors_should_be_10
    assert_equal 10, @elevator.floors
  end

  def test_move_floors_should_be_10
    assert_equal 10, Move.floors
  end

  def test_call_should_return_person_and_attributes
    @elevator.call(:down,3)
    assert_kind_of Person, Person.all.first
    assert_equal 3, Person.all.first.start
  end

  def test_direction_should_be_equal_to_first_call
    @elevator.call(:up,3)
    @elevator.call(:down,6)
    assert_equal :up, Move.direction
  end

  def test_person_should_only_be_created_when_in_good_direction
    @elevator.call(:up,3)
    @elevator.call(:down,6)
    assert_equal 1, Person.all.size
  end

  def test_person_should_create_several_persons_when_in_good_direction
    @elevator.call(:up,3)
    @elevator.call(:up,6)
    assert_equal 2, Person.all.size
  end

  def test_should_deliver_persons
    @elevator.call(:up,3)
    @elevator.call(:up,6)
    Person.all.each { |person| person.destination = 9 }
    created_persons = Person.all
    @elevator.perform
    assert_empty Person.all
    assert_includes Person.successes, created_persons.first
    assert_includes Person.successes, created_persons.last
  end

end
