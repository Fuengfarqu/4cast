class DashboardController < ApplicationController
  def index
    @sum_of_sku1 = Item.find_by(name: "SKU1").frequency_distributions.sum(:demand)

    # perform_monte_carlo
    perform_bootstrapping
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
    srand(101)
    @sku = "SKU-05465464684"
    original_demand = [0, 1, 1, 1, 1, 3, 4, 3, 0, 0, 0, 0, 1, 1, 0, 1, 0, 3, 3, 3, 0, 0, 0, 0]
    number_of_orginal_demand = original_demand.size
    sum_original_demand = original_demand.sum(0.0)

    @predictions = demand_forecast_values(original_demand)
    @graphable_demand_forecast_values = graphable_demand_forecast_values(@predictions, original_demand)
    @graphable_colors = ["#71FF33", "#FF5733"] + Array.new(@graphable_demand_forecast_values.count - 2, "#3393FF")
    @graphable_histogram = @predictions.flatten.histogram.transpose

    @arrays_of_forecasted_demand = []
    forecasted_demand_months = @predictions.map do |new_value|
        @arrays_of_forecasted_demand << new_value[number_of_orginal_demand..-1]
    end      
    
    @sum_of_demand_in_each_array = @arrays_of_forecasted_demand.map do |demands|
        @sum_of_demand_in_each_array = demands.sum(0.0)
    end

    # @graphable_sum_of_demand_in_each_array = @sum_of_demand_in_each_array.group_by{ |v| v }.map{ |k, v| [k, v.size] }

    @graphable_sum_of_demand_in_each_array = @sum_of_demand_in_each_array.histogram(15)
    
    @graphable_sum_of_demand_in_each_array[0] = @graphable_sum_of_demand_in_each_array[0].map {|el| el.round(2)}
    @graphable_sum_of_demand_in_each_array = @graphable_sum_of_demand_in_each_array.transpose


    
    

    #  ?? = arrays_of_forecasted_demand.unshift(max_numbers, min_numbers)

          
    @mean_of_all_array = @sum_of_demand_in_each_array.sum(0.0) / @sum_of_demand_in_each_array.size
        
    sum = @sum_of_demand_in_each_array.sum(0.0) { |demand| (demand - @mean_of_all_array) ** 2 }
    
    @standard_deviation = Math.sqrt(sum / (@sum_of_demand_in_each_array.size))
    
    @confidence_interval_95 = 1.960*(@standard_deviation/Math.sqrt(@sum_of_demand_in_each_array.size))
    


    # p upper = mean_of_predicted_periods + @confidence_interval_95
    # p lower = mean_of_predicted_periods - @confidence_interval_95
  end

  def demand_forecast_values(original_demand)
    predictions = []

    number_of_forecasted_period = 12

    50.times do
      demand = original_demand.dup
      number_of_forecasted_period.times do
        demand = PredictNextMonthService.new(demand, original_demand).call
      end
      predictions << demand
    end
    predictions
  end

  def graphable_demand_forecast_values(predictions, original_demand)
    # @max_numbers = @arrays_of_forecasted_demand.transpose.map(&:max)
    # @min_numbers = @arrays_of_forecasted_demand.transpose.map(&:min)
    # graphable_data = @arrays_of_forecasted_demand.unshift(@max_numbers, @min_numbers)
    graphable_data = predictions.map.with_index do |prediction, index|
      { 
        name: index, 
        data: prediction[original_demand.count..-1].map.with_index {|pr,index| ["Month #{[index+1]}",pr]}
      }
    end
  end
end