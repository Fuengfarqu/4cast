require 'histogram/array'

class FrequencyDistributionsController < ApplicationController
  before_action :set_frequency_distribution, only: %i[ show edit update destroy ]

  # GET /frequency_distributions or /frequency_distributions.json
  def index
    @frequency_distributions = FrequencyDistribution.all
    @items = Item.all.order(created_at: :ASC)
  end


  # GET /frequency_distributions/1 or /frequency_distributions/1.json
  def show
  end

  # GET /frequency_distributions/new
  def new
    @frequency_distribution = FrequencyDistribution.new
  end

  # GET /frequency_distributions/1/edit
  def edit
  end

  # POST /frequency_distributions or /frequency_distributions.json
  def create
    @frequency_distribution = FrequencyDistribution.new(frequency_distribution_params)

    respond_to do |format|
      if @frequency_distribution.save
        format.html { redirect_to frequency_distribution_url(@frequency_distribution), notice: "Frequency distribution was successfully created." }
        format.json { render :show, status: :created, location: @frequency_distribution }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @frequency_distribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /frequency_distributions/1 or /frequency_distributions/1.json
  def update
    respond_to do |format|
      if @frequency_distribution.update(frequency_distribution_params)
        format.html { redirect_to frequency_distribution_url(@frequency_distribution), notice: "Frequency distribution was successfully updated." }
        format.json { render :show, status: :ok, location: @frequency_distribution }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @frequency_distribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /frequency_distributions/1 or /frequency_distributions/1.json
  def destroy
    @frequency_distribution.destroy

    respond_to do |format|
      format.html { redirect_to frequency_distributions_url, notice: "Frequency distribution was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_frequency_distribution
      @frequency_distribution = FrequencyDistribution.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def frequency_distribution_params
      params.require(:frequency_distribution).permit(:month, :year, :demand, :frequency, :probability, :acumulative_probability)
    end
end
