class DashboardController < ApplicationController
  def index
    @sum_of_sku1 = Item.find_by(name: "SKU1").frequency_distributions.sum(:demand)
  end
end