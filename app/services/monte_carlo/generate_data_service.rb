class GenerateDataService
  attr_reader :predicted_demand
  attr_reader :prediction_result
  attr_reader :random_seed

  def initialize(consumed_qty:)
    @consumed_qty = consumed_qty
  end

  def call
    @predicted_demand = generate_predicted_demand
    @mean = calculate_mean_by_month
    # p @mean
    @prediction_result = round_mean_prediction
    p @prediction_result
  end

  private

  def generate_predicted_demand
    pseudo_random_number = []
    predicted_demand = []
    occurence = Array.new(12, 0)
    @random_seed = Random.new_seed
    r = Random.new(@random_seed)
    10.times do
      pseudo_random_number = Array.new(@consumed_qty) { r.rand() }
      # p pseudo_random_number
  
      @occurence_of_demand_MC = occurence.dup
      pseudo_random_number.each do |elements|
        perform_monte_carlo(elements)
      end
      predicted_demand << @occurence_of_demand_MC
    end
    predicted_demand
  end

  def perform_monte_carlo(elements)
    case elements
    when 0 .. 0.03333333333 #JAN
        @occurence_of_demand_MC[0] += 1
    when 0.03333333334 .. 0.06666666666 #FEB
        @occurence_of_demand_MC[1] += 1
    when 0.06666666667 .. 0.09999999999 #MAR
        @occurence_of_demand_MC[2] += 1
    when 0.10000000000 .. 0.13333333332 #APR
        @occurence_of_demand_MC[3] += 1
    when 0.13333333333 .. 0.16666666665 #MAY
        @occurence_of_demand_MC[4] += 1
    when 0.16666666666 .. 0.39999999998 #JUNE
        @occurence_of_demand_MC[5] += 1
    when 0.39999999999 .. 0.63333333331 #JULY
        @occurence_of_demand_MC[6] += 1
    when 0.63333333332 .. 0.86666666664 #AUG
        @occurence_of_demand_MC[7] += 1
    when 0.86666666665 .. 0.89999999997 #SEP
        @occurence_of_demand_MC[8] += 1
    when 0.89999999998 .. 0.9333333333 #OCT
        @occurence_of_demand_MC[9] += 1
    when 0.9333333333 .. 0.96666666663 #NOV
        @occurence_of_demand_MC[10] += 1
    else #DEM
        @occurence_of_demand_MC[11] += 1
    end
  end

  def calculate_mean_by_month
    @predicted_demand.transpose.map do |demands_by_month| 
      demands_by_month.sum(0.0) / demands_by_month.size
    end
  end

  def round_mean_prediction
    result = Array.new(12, 0)
    
    while result.sum < @consumed_qty 
      max_index = @mean.each_with_index.max.last
      if @mean[max_index] > 1.0 
        result[max_index] = @mean[max_index].round
      else
        result[max_index] = 1
      end
      @mean[max_index] = 0
    end
    
    result
  end
end

# p GenerateDataService.new(consumed_qty: 20).call