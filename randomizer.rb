class Randomizer

  attr_reader :current_floor, :limit, :direction
  def initialize(params)
    @current_floor = params[:current_floor]
    @limit = params[:limit]
    @direction = params[:direction]
  end

  def destination
    randomize(true_limit)
  end

  def call
    randomize(limit)
  end

  private
  def randomize(limit)
    if limit == 0 || limit == 1
      limit = 0..1
    end
    prng = Random.new
    prng.rand(limit)
  end

  def true_limit
    return current_floor if direction == :down && current_floor == 0
    return current_floor - 1 if direction == :down && current_floor > 0
    (current_floor + 1)..limit
  end

end
