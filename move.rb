class Move

  DIRECTIONS = [:up, :down]
  class << self
    attr_accessor :direction, :floors, :current_floor, :ongoing
  end
  @direction = :not_set
  @floors = 0
  @current_floor = 0
  @ongoing = false

  def self.begin_message
    puts "> Ascenseur est au #{self.current_floor}"
  end

  def self.change_direction(new_direction)
    self.direction = new_direction if direction == :not_set
  end

  def self.set_floors_numbers(floors_number)
    self.floors = floors_number
  end

  def self.in_set_direction
    direction == :up ? self.up : self.down
  end

  def self.up
    self.move_elevator_up
    puts "> Ascenseur monte au #{current_floor} étage ()"
  end

  def self.move_elevator_up
    return self.current_floor += 1 if current_floor < floors
    self.current_floor = floors
  end

  def self.down
    self.move_elevator_down
    puts "> Ascenseur descend au #{current_floor} étage ()"
  end

  def self.move_elevator_down
    return self.current_floor -= 1 if current_floor >= 1
    self.current_floor = 0
  end

end
