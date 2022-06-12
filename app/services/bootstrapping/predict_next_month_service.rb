class PredictNextMonthService
  def initialize(new_demands:, original_demand:, jittering_type:)
    @new_demand = nil
    @all_demands = original_demand + new_demands
    @original_demand = original_demand
    @jittering_type = jittering_type
  end

  def call
    set_occurence_of_demand
    calculate_month_with_without_demands
    calculate_4_conditional_probabilities
    set_rand_uniform_distribution
    add_new_occurance
    add_forecast_value_to_demand
    @new_demand
  end

  private
  def set_occurence_of_demand
    # Record a month with a demand occurrence as ‘1’ and a month without a demand occurrence as ‘0’
    @occurrence_of_demand = @all_demands.map do |d|
      d > 0 ? 1 : d
    end
  end

  def calculate_month_with_without_demands
    # count how many months with demands/without demands?
    months_with_demands = @occurrence_of_demand.count(1)
    months_without_demands = @occurrence_of_demand.count(0)

    #discount the last observation, as we do not know what happened on the next day
    @number_of_months_with_demands = months_with_demands
    @number_of_months_without_demands = months_without_demands

    if @occurrence_of_demand.last == 0
      @number_of_months_without_demands -= 1
    elsif @occurrence_of_demand.last == 1
      @number_of_months_with_demands -= 1
    end
  end

  def calculate_4_conditional_probabilities
    #  Out of xx months with demand,
    #  - how many ocssions when the next month also had demand?
    #  - how many ocssions when the next month had no demand?
    #  Out of x months without demand,
    #  - how many ocssions when the next month had demand?
    #  - how many ocssions when the next month also had no demand?

    demand_and_demand = 0
    demand_and_no_demand = 0
    no_demand_and_demand = 0
    no_demand_and_no_demand = 0
    @occurrence_of_demand.each_cons(2) do |occurance_a, occurance_b|
      if occurance_a == 1 && occurance_b == 1
        demand_and_demand += 1
      end
      if occurance_a == 1 && occurance_b == 0
        demand_and_no_demand += 1
      end
      if occurance_a == 0 && occurance_b == 1
        no_demand_and_demand += 1
      end
      if occurance_a == 0 && occurance_b == 0
        no_demand_and_no_demand += 1
      end
    end

    @probability_of_demand_and_demand = demand_and_demand.to_f / @number_of_months_with_demands.to_f

    @probability_of_demand_and_no_demand = demand_and_no_demand.to_f / @number_of_months_with_demands.to_f

    @probability_of_no_demand_and_demand = no_demand_and_demand.to_f / @number_of_months_without_demands.to_f

    @probability_of_no_demand_and_no_demand = no_demand_and_no_demand.to_f / @number_of_months_without_demands.to_f
  end

  def set_rand_uniform_distribution
    @rand_uniform_distribution = Random.rand()
  end

  def add_new_occurance
    #occurrence_of_demand - even after forecast n period
    @occurrence_of_demand << decide_if_demand_occurs
  end

  def decide_if_demand_occurs
    if @occurrence_of_demand.last == 1
      @rand_uniform_distribution < @probability_of_demand_and_demand ? 1 : 0
    else
      @rand_uniform_distribution < @probability_of_no_demand_and_demand ? 1 : 0
    end
  end

  def add_forecast_value_to_demand
    if @occurrence_of_demand.last == 1
      @new_demand = perform_jittering
    else
      @new_demand = 0
    end
  end

  def perform_jittering
    Jittering.new(original_demand: @original_demand, jittering_type: @jittering_type).call
  end
end