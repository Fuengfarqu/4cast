class Jittering
  def initialize(original_demand:, jittering_type:)
    @demand = original_demand
    @jittering_type = jittering_type
  end

  def call
    pick_demand
    generate_guassian_random_numbers
    if @jittering_type == "1"
      jittering_1
    else
      jittering_2
    end
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

  def jittering_1
    jittered_demand = nil
    value = 1 + ( @demand_sample + (@rand_normal_distribution * Math.sqrt(@demand_sample)) ).to_i
    if value > 0
      jittered_demand = value
    else
      jittered_demand = @demand_sample
    end
    jittered_demand
  end

  def jittering_2
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