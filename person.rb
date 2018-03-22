class Person

  @@instances = []
  @@counter = 0
  attr_reader :start, :id
  attr_accessor :destination

  def initialize(params)
    @start = params[:start]
    @destination = params[:destination]
    @@counter += 1
    @id = "personne_#{Person.count}"
    @@instances << self
  end

  def ask_elevator
    puts "> #{id} veut prendre l'ascenseur au #{start} étage"
    puts ""
  end

  def self.set_destination_of_persons_on_this_floor(floor,current_floor)
    self.wait_at(current_floor).each do |person|
      person.destination = floor
      destination_message(person,current_floor)
    end
  end

  def self.destination_message(person,current_floor)
    puts ""
    puts "> #{person.id} embarque au #{current_floor} étage (#{self.show_destinations})"
    puts ""
  end

  def self.arrived?(current_floor)
    self.arrived_messages(current_floor) if self.destinations.include?(current_floor)
  end

  def self.all
    @@instances
  end

  def self.count
    @@counter
  end

  def self.starts
    @@instances.map { |person| person.start }
  end

  def self.destinations
    @@instances.map { |person| person.destination }.compact
  end

  def self.show_destinations
    @@instances.map do |person|
      "#{person.id} : #{person.destination}" if person.destination
    end.compact.join(", ")
  end

  def self.wait_at(current_floor)
    @@instances.select{ |person| person.start == current_floor }
  end

  def self.arrived(current_floor)
    @@instances.select{ |person| person.destination == current_floor }
  end

  def self.first
    @@instances.first
  end

  def self.last_stop(direction)
    direction == :up ? self.highest_stop : self.lowest_stop
  end

  private

  def self.lowest_stop
    return self.starts.min if self.starts.min < self.destinations.min
    self.destinations.min
  end

  def self.highest_stop
    return self.starts.max if self.starts.max > self.destinations.max
    self.destinations.max
  end

  def self.arrived_messages(current_floor)
    puts ""
    self.arrived(current_floor).each do |person|
      puts "> #{person.id} débarque au #{current_floor} ()"
    end
    puts ""
  end

end
