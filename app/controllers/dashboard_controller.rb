class DashboardController < ApplicationController
  def dashboard_1
    @sum_of_sku1 = Item.find_by(name: "SKU1").frequency_distributions.sum(:demand)
    @jittering_type = "1"
    # perform_monte_carlo
    perform_bootstrapping
    render :index
  end

  def dashboard_2
    @jittering_type = "2"
    perform_bootstrapping
    render :index
  end

  private

  def perform_monte_carlo
    service = GenerateDataService.new(consumed_qty: 14)
    service.call    
    @predicted_demand = service.predicted_demand.map.with_index do |monte_result,index|
      { 
        name: index, 
        data: monte_result.map.with_index {|mb,index| [Date::MONTHNAMES[index+1],mb]}
      }
    end
    @prediction_result = service.prediction_result #.map.with_index {|v,i| [i,v]}
    @random_seed = service.random_seed
  end

  def perform_bootstrapping
    # @random_seed_bootstrapping = 31716703659525654123013612295258305090
    # srand(@random_seed_bootstrapping)
    @sku_name = "SKU-1000000077504"
    original_demand = [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0]


    number_of_orginal_demand = original_demand.size
    @sum_original_demand = original_demand.sum(0.0)

    @predictions = demand_forecast_values(original_demand)
    @graphable_demand_forecast_values = graphable_demand_forecast_values(@predictions, original_demand)
    @graphable_colors = ["#0d6efd", "#0d6efd"] + Array.new(@graphable_demand_forecast_values.count - 2, "#212529")
    @graphable_histogram = @predictions.flatten.histogram.transpose     
    
    @sum_of_demand_in_each_array = @predictions.map do |demands|
        @sum_of_demand_in_each_array = demands.sum(0.0)
    end

    # @graphable_sum_of_demand_in_each_array = @sum_of_demand_in_each_array.group_by{ |v| v }.map{ |k, v| [k, v.size] }

    @graphable_sum_of_demand_in_each_array = @sum_of_demand_in_each_array.histogram(6)
    
    @graphable_sum_of_demand_in_each_array[0] = @graphable_sum_of_demand_in_each_array[0].map {|el| el.round(2)}
    @graphable_sum_of_demand_in_each_array = @graphable_sum_of_demand_in_each_array.transpose
          
    @mean_of_all_array = @sum_of_demand_in_each_array.sum(0.0) / @sum_of_demand_in_each_array.size
        
    sum = @sum_of_demand_in_each_array.sum(0.0) { |demand| (demand - @mean_of_all_array) ** 2 }
    
    @standard_deviation = Math.sqrt(sum / (@sum_of_demand_in_each_array.size))

    @confidence_interval_90 = 1.645*(@standard_deviation/Math.sqrt(@sum_of_demand_in_each_array.size))

    @confidence_interval_95 = 1.960*(@standard_deviation/Math.sqrt(@sum_of_demand_in_each_array.size))

    @confidence_interval_99 = 2.576*(@standard_deviation/Math.sqrt(@sum_of_demand_in_each_array.size))

    @confidence_interval_99_99 = 3.291*(@standard_deviation/Math.sqrt(@sum_of_demand_in_each_array.size))


  end

  def demand_forecast_values(original_demand)
    predictions = []
    @number_of_samples = 1000
    number_of_forecasted_period = 12

    @number_of_samples.times do
      demands = []
      number_of_forecasted_period.times do
        demands << PredictNextMonthService.new(new_demands: demands, original_demand: original_demand, jittering_type: @jittering_type).call
      end
      predictions << demands
    end
    predictions
  end

  def graphable_demand_forecast_values(predictions, original_demand)
    predictions_with_min_max = predictions.dup
    max_numbers = predictions_with_min_max.transpose.map(&:max)
    min_numbers = predictions_with_min_max.transpose.map(&:min)

    predictions_with_min_max = predictions_with_min_max.unshift(max_numbers, min_numbers)
    graphable_data = predictions_with_min_max.map.with_index do |demands, index|
      { 
        name: index, 
        data: demands.map.with_index {|pr,index| ["Month #{[index+1]}",pr]}
      }
    end
  end
end