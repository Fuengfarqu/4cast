class Jittering
  def initialize(demand)
    @demand = demand
  end

  def call
    pick_demand
    generate_guassian_random_numbers
    jittering
  end

  private

  def pick_demand
    picked_demands = []
    @demand.each do |d|
      picked_demands << d if d > 0
    end

    @demand_sample = picked_demands.sample
  end

  def generate_guassian_random_numbers
    normal_distribution_generrator = RandomGaussian.new(0, 1)
    @rand_normal_distribution = normal_distribution_generrator.rand
  end

  def jittering
    jittered_demand = nil
    value = 0.5 + @demand_sample + (@rand_normal_distribution * Math.sqrt(@demand_sample))
    if value > 0
      jittered_demand = value.to_i
    else
      jittered_demand = 1
    end
    jittered_demand
  end
end